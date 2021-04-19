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

const cardsMock = 'W3siYVNpZGUiOiJkdXBhIiwiYlNpZGUiOiJhcnNlIn0seyJhU2lkZSI6ImZpdXQiLCJiU2lkZSI6ImRpY2sifSx' +
    '7ImFTaWRlIjoia3V0YXNpYXJ6IiwiYlNpZGUiOiJhc3Nob2xlIn0seyJhU2lkZSI6InpqZWIiLCJiU2lkZSI6ImN1bnQifSx7ImFTaW' +
    'RlIjoiY2lwa2EiLCJiU2lkZSI6InB1c3N5In1d';

const key = 'trudnasprawatakieaplickacjewelmie:vocab';

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
    const flags = await db.get(key).then(v => v || `{"cards":${atob(cardsMock)},"archived":[]}`).then(decode);
    const save = data => {
        console.log(data);
        db.set(key, encode(data));
    };
    document.body.replaceChild(node, document.getElementById('loading'));
    const app = Elm.Main.init({node, flags});
    app.ports.syncData.subscribe(save);
    const update = data => {
        app.ports.loadedExternalData.send(data);
        return data;
    }
    app.ports.loadExternalData.subscribe(() => {
        fetch(atob(U)).then(r => r.json())
            .then(d => d.values.slice(1)
                .map(([aSide, fon, bSide, desc]) => ({aSide, bSide})))
            .then(update)
            .then(cards => ({cards, archived: []}))
            .then(save)
            .catch(e => {
                console.error(e);
            });
    })
}
