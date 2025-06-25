// /assets/smrt_pay/smrt-payment-widget.js
// v1.0 Universal SMRT Payment Widget — embeddable, scalable, event-ready
(function (window) {
  if (window.SMRTPayWidget) return; // Prevent double load

  // Main Widget Class
  class SMRTPayWidget {
    static DEFAULTS = {
      env: '',
      mode: 'charge',
      total: 0,
      achTotal: null,
      ACH: false,
      saveRealACH: false,
      cashDiscount: false,
      sandbox: true,
      elevenLabs: true,
      targetDiv: '#smrt-pay',
      debug: false,
      branding: { logo: '/assets/logo.png', title: '$MRT PAY' },
      customFields: [],
      binListUrl: '/assets/smrt_pay/binlist.json',
      overlay: null, // Optional branding overlay URL
      eventHooks: {},
      auditLogUrl: null, // POST audit logs here
      usePlaid: false,
      plaidPublicKey: '', // Set by site
      plaidEnv: 'sandbox', // or 'production'
      // More: see TODO
    };

    constructor(config = {}) {
      this.cfg = { ...SMRTPayWidget.DEFAULTS, ...config };
      this.state = { binData: [], loading: false, errors: [], result: null, form: {} };
      if (this.cfg.debug) window.smrtpay = this; // Expose for debugging
      this._audit('init', { cfg: this.cfg });
    }
    
    // inside SMRTPayWidget class
    async _getCachedBinInfo(bin) {
         // First try local cache
         try {
            let cache = await fetch('/assets/SMRT-Pay/binlist-cached.json');
             let list = await cache.json();
             let rec = list.find(x => x.bin === bin);
         if (rec) return rec;
         } 
         catch (e) {/* not fatal */}

  // If not found, fetch live
  let r = await this._fetchBinlistNet(bin);
  if (r) {
    // Send to backend to cache (implement /assets/SMRT-Pay/binlist-add.php)
    fetch('/assets/SMRT-Pay/binlist-add.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ bin, ...r })
    });
    return r;
  }
  return null;
}
    async init() {
      await this._loadBinData();
      this._render();
      if (this.cfg.usePlaid) this._setupPlaid();
      if (this.cfg.elevenLabs) this._setupElevenLabs();
    }

    // --- BIN, Luhn, Category
    _luhn(num) {
      let arr = (num + '').split('').reverse().map(x => parseInt(x)); let sum = arr.reduce((acc, val, i) => acc + (i % 2 ? ((val *= 2) > 9 ? val - 9 : val) : val), 0);
      return sum % 10 === 0;
    }

    _getBinType(pan) {
      let bin = pan.slice(0, 6), rec = this.state.binData.find(b => b.bin === bin);
      if (rec) return rec.type;
      // fallback to binlist.net
      return null;
    }

    async _fetchBinlistNet(bin) {
      try {
        let r = await fetch(`https://lookup.binlist.net/${bin}`);
        if (!r.ok) throw new Error('BIN fetch failed');
        return await r.json();
      } catch (e) {
        if (this.cfg.debug) console.warn('BINLIST.NET error:', e);
        return null;
      }
    }

    async _loadBinData() {
      try {
        let r = await fetch(this.cfg.binListUrl); this.state.binData = await r.json();
      } catch (e) {
        if (this.cfg.debug) console.warn('Local BIN list load failed:', e);
        this.state.binData = [];
      }
    }

    // --- Audit/Event Hooks
    _audit(event, data) {
      if (this.cfg.auditLogUrl) {
        fetch(this.cfg.auditLogUrl, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ event, data, ts: Date.now() })
        });
      }
      if (this.cfg.eventHooks[event]) this.cfg.eventHooks[event](data);
    }

    // --- ElevenLabs Widget
    _setupElevenLabs() {
      if (window.customElements && !window.elevenLabsLoaded) {
        let scr = document.createElement('script');
        scr.src = "https://unpkg.com/@elevenlabs/convai-widget-embed";
        scr.async = true; scr.type = "text/javascript";
        document.body.appendChild(scr);
        window.elevenLabsLoaded = true;
      }
    }

    // --- Plaid Scaffold
    _setupPlaid() {
      if (!this.cfg.plaidPublicKey) return;
      let scr = document.createElement('script');
      scr.src = "https://cdn.plaid.com/link/v2/stable/link-initialize.js";
      scr.onload = () => {
        window.Plaid.create({
          token: this.cfg.plaidPublicKey,
          onSuccess: (pubToken, meta) => this._audit('plaidSuccess', { pubToken, meta }),
          onExit: (err, meta) => this._audit('plaidExit', { err, meta }),
        }).open();
      };
      document.body.appendChild(scr);
    }

    // --- Main Render Logic: see next chunk
    _render() { /* next code block */ }
  }

  // Global Attach
  window.SMRTPayWidget = {
    init: (cfg) => {
      let widget = new SMRTPayWidget(cfg);
      widget.init();
      return widget;
    }
  };
})(window);
// (continuation of SMRTPayWidget class...)
_render() {
  const div = document.querySelector(this.cfg.targetDiv);
  if (!div) return;
  div.innerHTML = `
    <div class="smrtpay-widget">
      <div class="smrtpay-brand-bar">
        <img src="${this.cfg.branding.logo}" class="smrt-logo" alt="Logo" />
        <span class="smrt-title">${this.cfg.branding.title}</span>
      </div>
      <form id="smrtpay-form">
        <label>Card Number</label>
        <input type="tel" name="pan" maxlength="19" placeholder="1234 5678 9012 3456" required autocomplete="cc-number"/>
        <label>Exp. (MM/YY)</label>
        <input type="text" name="exp" maxlength="5" placeholder="MM/YY" required autocomplete="cc-exp"/>
        <label>CVV</label>
        <input type="text" name="cvv" maxlength="4" placeholder="123" required autocomplete="cc-csc"/>
        <label>Name on Card</label>
        <input type="text" name="name" maxlength="64" placeholder="Cardholder Name" required autocomplete="cc-name"/>
        ${this.cfg.ACH ? `<hr /><label>or ACH Routing #</label>
        <input type="text" name="achRouting" maxlength="9" placeholder="123456789"/>
        <label>ACH Account #</label>
        <input type="text" name="achAccount" maxlength="17" placeholder="00000000000000000"/>
        ` : ''}
        ${this.cfg.customFields.map(f => `<label>${f.label}</label>
        <input type="${f.type}" name="${f.name}" ${f.required ? 'required' : ''} />`).join('')}
        <button type="submit">${this.cfg.mode.startsWith('auth') ? 'Pre-Authorize' : 'Pay'} ${this.cfg.total ? ('$' + this.cfg.total) : ''}</button>
        <div class="smrtpay-error" style="display:none;"></div>
        <div class="smrtpay-success" style="display:none;"></div>
      </form>
      ${this.cfg.elevenLabs ? `
        <div class="smrtpay-elevenlabs-toggle">
          <input type="checkbox" id="elabs-toggle" checked/>
          <label for="elabs-toggle">Enable Voice Assistant</label>
        </div>
        <div id="elevenlabs-widget"></div>
      ` : ''}
      ${this.cfg.overlay ? `<img src="${this.cfg.overlay}" class="smrtpay-overlay" />` : ''}
    </div>
  `;
  // Add handlers
  const form = div.querySelector('#smrtpay-form');
  const err = div.querySelector('.smrtpay-error');
  const ok = div.querySelector('.smrtpay-success');
  form.onsubmit = async (e) => {
    e.preventDefault();
    err.style.display = 'none'; ok.style.display = 'none';
    let d = Object.fromEntries(new FormData(form));
    if (!this._luhn(d.pan)) { err.textContent = 'Invalid card number (failed Luhn check)'; err.style.display = 'block'; return; }
    let binType = this._getBinType(d.pan);
    // If not found locally, fallback to binlist.net
    if (!binType) {
      let r = await this._fetchBinlistNet(d.pan.slice(0,6));
      binType = r?.type || 'UK';
    }
    // TODO: Apply .env rules if mode=bin; show/hide/deny as appropriate

    // Scaffold: Payment logic, send to iPOSPay API here
    this._audit('formSubmit', { d, binType });
    ok.textContent = "✓ Payment submitted (stub) — server logic required";
    ok.style.display = 'block';
    // (more complex logic/TODO: ACH, Plaid, etc. per your config)
  };

  // ElevenLabs voice toggle logic
  const elabsToggle = div.querySelector('#elabs-toggle');
  if (elabsToggle) {
    elabsToggle.onchange = (ev) => {
      document.getElementById('elevenlabs-widget').innerHTML = elabsToggle.checked
        ? `<elevenlabs-convai agent-id="agent_01jyjgxereekmrv21389k3fy2s"></elevenlabs-convai><script src="https://unpkg.com/@elevenlabs/convai-widget-embed" async type="text/javascript"></script>`
        : '';
    };
    elabsToggle.onchange();
  }
}
