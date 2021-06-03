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

const dataUri = (id, key, sheet = 'Sheet1') => `https://sheets.googleapis.com/v4/spreadsheets/${id}/values/${sheet}!A:D?key=${key}`

async function initApp() {
    const db = ImmortalDB.ImmortalDB
    const node = document.createElement('pre');
    const flags = await db.get(dataKey).then(v => v || `{"cards":[],"archived":[],"creds":{}}`).then(decode);
    const save = data => {
        console.log(data);
        db.set(dataKey, encode(data));
    };
    document.body.replaceChild(node, document.getElementById('loading'));
    const app = Elm.Main.init({node, flags});
    app.ports.syncData.subscribe(save);
    const update = data => {
        app.ports.loadedExternalData.send(data);
        return data;
    }
    app.ports.loadExternalData.subscribe(({apiKey, dataId, sheet}) => {
        if (!apiKey || !dataId) {
            console.error(`Wrong creds: apiKey: ${apiKey}, dataId: ${dataId}`);
            return;
        }
        fetch(dataUri(dataId?.trim(), apiKey?.trim(), sheet?.trim() || undefined)).then(r => r.json())
            .then(d => d.values.slice(1)
                .filter(([a, _, b]) => !!a && !!b)
                .map(([aSide, fon, bSide, desc]) => ({aSide, bSide})))
            .then(update)
            .then(cards => ({cards, archived: []}))
            .then(save)
            .catch(e => {
                console.error(e);
            });
    });
    app.ports.resetAll.subscribe(() => {
        db.remove(dataKey);
    });
}
