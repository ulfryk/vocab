const initApp = (({IndexedDbStore, LocalStorageStore, ImmortalStorage}) => {

    const dataKey = 'trudnasprawatakieaplickacjewelmie:vocab';

    const encode = data => {
        try {
            return JSON.stringify(data);
        } catch (e) {
            console.error(e);
            return null;
        }
    }

    const decode = value => {
        try {
            return JSON.parse(value)
        } catch (e) {
            console.error(e);
            return null;
        }
    }

    return async function initApp() {
        const stores = [await new IndexedDbStore(), await new LocalStorageStore()]
        const db = new ImmortalStorage(stores)
        const node = document.createElement('pre');
        const flags = await db.get(dataKey).then(v => v || '{}').then(decode);
        // console.log('flags', flags);
        document.body.replaceChild(node, document.getElementById('loading'));
        Elm.Main.init({node, flags}).ports.syncData.subscribe(data => {
            // console.log('sync', data);
            db.set(dataKey, encode(data));
        });
    }

})

if ('serviceWorker' in navigator) {
    window.addEventListener('load', () => {
        navigator.serviceWorker.register('sw.js').then(registration => {
            // Registration was successful
            // console.log('ServiceWorker registration successful with scope: ', registration.scope);
        }, err => {
            // registration failed :(
            // console.log('ServiceWorker registration failed: ', err);
            console.error(err);
        });
        initApp(ImmortalDB)();
    });
}
