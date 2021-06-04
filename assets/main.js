if ('serviceWorker' in navigator) {
    window.addEventListener('load', () => {
        navigator.serviceWorker.register('sw.js').then(registration => {
            // Registration was successful
            console.log('ServiceWorker registration successful with scope: ', registration.scope);
        }, err => {
            // registration failed :(
            console.log('ServiceWorker registration failed: ', err);
        });
        initApp();
    });
}

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

async function initApp() {
    const db = ImmortalDB.ImmortalDB
    const node = document.createElement('pre');
    const flags = await db.get(dataKey).then(v => v || `{"cards":[],"archived":[],"creds":{}}`).then(decode);
    document.body.replaceChild(node, document.getElementById('loading'));
    const app = Elm.Main.init({node, flags});
    app.ports.syncData.subscribe(data => {
        db.set(dataKey, encode(data));
    });
    app.ports.resetAll.subscribe(() => {
        db.remove(dataKey);
    });
}
