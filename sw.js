const CACHE_NAME = 'vocab-cache-v1';

const urlsToCache = [
    'assets/style.css',
    'assets/main.js',
    'assets/elm.js',
    'assets/immortaldb.min.js'
];

self.addEventListener('install', event => {
    console.log('install successful', event)
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => {
                console.log('Opened cache');
                return cache.addAll(urlsToCache);
            })
    );
});
