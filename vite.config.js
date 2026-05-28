import { defineConfig } from 'vite';

export default defineConfig({
  root: 'public',
  build: {
    outDir: '../dist',
    emptyOutDir: true,
    rollupOptions: {
      input: {
        main: 'public/index.html',
        projects: 'public/pages/projects.html',
        topics: 'public/pages/topics.html',
        project: 'public/pages/project.html',
        topic: 'public/pages/topic.html',
        multisim: 'public/pages/multisim.html',
        tinkercad: 'public/pages/tinkercad.html',
        userProfile: 'public/pages/user-profile.html'
      }
    }
  },
  server: {
    middlewareMode: false,
    proxy: {
      '/api': {
        target: 'http://localhost:3000',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, '/api')
      }
    }
  }
});
