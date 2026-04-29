/// Lume Cortex — Service Worker (PWA)
/// Caches the shell + assets for offline/install capability

const CACHE_NAME = 'cortex-v1';
const SHELL_ASSETS = [
  '/',
  '/index.html',
  '/dist/cortex.js',
  '/manifest.json',
  '/assets/img/hero.png',
  '/assets/img/finance.png',
  '/assets/img/sports.png',
  '/assets/img/gaming.png',
  '/assets/img/security.png',
  '/assets/img/creative.png',
  '/assets/img/social.png',
  '/assets/img/auto.png',
  '/assets/img/wellness.png',
  '/assets/img/realestate.png'
];

self.addEventListener('install', (e) => {
  e.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(SHELL_ASSETS))
  );
  self.skipWaiting();
});

self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', (e) => {
  // Network-first for API calls, cache-first for assets
  if (e.request.url.includes('/v1/') || e.request.url.includes('/api/')) {
    e.respondWith(fetch(e.request).catch(() => caches.match(e.request)));
  } else {
    e.respondWith(
      caches.match(e.request).then((cached) => cached || fetch(e.request))
    );
  }
});
