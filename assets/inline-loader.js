// Inline Asset Loader - Embeds assets directly without external requests
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
    
    // Create and inject CTO signature with inline SVG
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
        
        // Inline SVG to avoid external requests
        signature.innerHTML = `
            <svg width="100" height="50" xmlns="http://www.w3.org/2000/svg">
                <rect width="100" height="50" fill="transparent"/>
                <text x="10" y="20" font-family="Arial, sans-serif" font-size="12" fill="black" opacity="0.8">CTO</text>
                <text x="10" y="35" font-family="Arial, sans-serif" font-size="10" fill="gray" opacity="0.6">Signature</text>
            </svg>
        `;
        
        document.body.appendChild(signature);
        console.log('CTO signature injected');
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
        
        // Load ElevenLabs script inline
        const script = document.createElement('script');
        script.src = 'https://unpkg.com/@elevenlabs/convai-widget-embed';
        script.async = true;
        script.type = 'text/javascript';
        
        script.onload = function() {
            console.log('ElevenLabs widget loaded for domain:', prefix);
            
            // Create the widget element
            const widget = document.createElement('elevenlabs-convai');
            widget.setAttribute('agent-id', 'AGENT_ID_FOR_' + prefix.toUpperCase());
            container.appendChild(widget);
        };
        
        script.onerror = function() {
            console.warn('ElevenLabs widget script failed to load');
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
        
        console.log('Initializing inline asset loader...');
        
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