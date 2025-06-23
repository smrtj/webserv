module.exports = {
  apps: [
    {
      name: 'openwebui-smrt',
      script: 'vite',
      args: 'preview --port 5173',
      cwd: '/var/www/openwebui-chat-smrt',
      env: {
        NODE_ENV: 'production'
      }
    }
  ]
};

