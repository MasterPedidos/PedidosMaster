const CACHE_NAME = "pm-cache-v1";

self.addEventListener("install", event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      return cache.addAll([
        "./",  // Garante que o arquivo inicial do PWA seja cacheado
        "index.html",
        "produtos.json",
        "manifest.json",
        "ativo/logo.svg",  // Atualiza o logo
        "ícone/ícone-192.png",  // Atualiza o ícone 192
        "ícone/ícone-512.png"   // Atualiza o ícone 512
      ]);
    })
  );
  self.skipWaiting();
});

self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(
        keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k))
      )
    )
  );
  self.clients.claim();
});

self.addEventListener("fetch", event => {
  event.respondWith(
    caches.match(event.request).then(response => {
      return (
        response ||  // Caso não ache na cache, vai fazer o fetch normalmente
        fetch(event.request).then(fetchResponse => {
          const clone = fetchResponse.clone();
          caches.open(CACHE_NAME).then(cache => {
            cache.put(event.request, clone);
          });
          return fetchResponse;
        })
      );
    })
  );
});
