// SMRT/KJO/HackServ Universal Asset Loader
// Injects persistent UI elements into all pages across all domains

(function() {
    'use strict';
    
    // Domain prefix mapping
    const DOMAIN_PREFIXES = {
        'smrtpayments.com': 'smrt',
        'teamkjo.com': 'kjo',
        'kjo.ai': 'kjo',
        'hackserv.cc': 'hack',
        'hackserv.org': 'hack'
    };
    
    // Get domain prefix based on hostname
    function getDomainPrefix() {
        const hostname = window.location.hostname;
        for (const domain in DOMAIN_PREFIXES) {
            if (hostname.includes(domain)) {
                return DOMAIN_PREFIXES[domain];
            }
        }
        return 'smrt'; // default fallback
    }
    
    // Create and inject CTO signature
    function injectCTOSignature() {
        const signature = document.createElement('div');
        signature.id = 'cto-signature';
        signature.style.cssText = `
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 9999;
            pointer-events: none;
            opacity: 0.8;
        `;
        
        const img = document.createElement('img');
        img.src = '/assets/cto.sig.svg';
        img.alt = 'CTO Signature';
        img.style.cssText = `
            max-width: 100px;
            max-height: 50px;
            width: auto;
            height: auto;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3));
        `;
        
        // Handle image load error
        img.onerror = function() {
            console.warn('CTO signature image not found:', img.src);
            signature.style.display = 'none';
        };
        
        signature.appendChild(img);
        document.body.appendChild(signature);
    }
    
    // Create and inject ElevenLabs widget
    function injectElevenLabsWidget() {
        const prefix = getDomainPrefix();
        
        // Create container for ElevenLabs widget
        const container = document.createElement('div');
        container.id = 'elevenlabs-widget-container';
        container.style.cssText = `
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 9998;
            pointer-events: auto;
        `;
        
        // Load domain-specific ElevenLabs script
        const script = document.createElement('script');
        script.src = '/elevenlabs.js';
        script.async = true;
        script.type = 'text/javascript';
        
        script.onload = function() {
            console.log('ElevenLabs widget loaded for domain:', prefix);
        };
        
        script.onerror = function() {
            console.warn('ElevenLabs widget script not found:', script.src);
        };
        
        document.head.appendChild(script);
        document.body.appendChild(container);
    }
    
    // Initialize when DOM is ready
    function init() {
        // Check if elements already exist to avoid duplicates
        if (document.getElementById('cto-signature') || document.getElementById('elevenlabs-widget-container')) {
            return;
        }
        
        injectCTOSignature();
        injectElevenLabsWidget();
    }
    
    // Run when DOM is loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
    
    // Also run after a short delay to ensure it works on dynamic pages
    setTimeout(init, 1000);
    
})();