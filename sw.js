var V='jus-v1',F=['./','index.html','config.js','vendor/supabase.js','icons/icon-192.png','icons/favicon-32.png','fonts/ibm-plex-sans-latin-400-normal.woff2','fonts/ibm-plex-sans-latin-500-normal.woff2','fonts/ibm-plex-sans-latin-600-normal.woff2','fonts/ibm-plex-serif-latin-600-normal.woff2','fonts/ibm-plex-mono-latin-400-normal.woff2','fonts/ibm-plex-mono-latin-500-normal.woff2'];
self.addEventListener('install',function(e){e.waitUntil(caches.open(V).then(function(c){return c.addAll(F)}));self.skipWaiting()});
self.addEventListener('activate',function(e){e.waitUntil(caches.keys().then(function(k){return Promise.all(k.filter(function(x){return x!==V}).map(function(x){return caches.delete(x)}))}))});
self.addEventListener('fetch',function(e){
  var U=new URL(e.request.url);if(e.request.method!=='GET'||U.origin!==location.origin||U.pathname.indexOf('/api/')===0||U.pathname.indexOf('/_vercel/')===0)return;
  e.respondWith(fetch(e.request).then(function(r){var c=r.clone();caches.open(V).then(function(h){h.put(e.request,c)});return r}).catch(function(){return caches.match(e.request)}));
});
