# AI-Konsultplattform

En fullstack-startmall för en AI-konsultplattform: **React** (Vite) i frontend, **Django** i backend och **PostgreSQL** som databas, allt körbart med Docker Compose. Backend har redan beroenden för AI-funktionalitet (LangChain, LangGraph, OpenAI och ChromaDB), men ännu ingen AI-logik. Just nu är projektet ett fungerande skelett där frontend anropar ett API i backend.

## Status

Det här är en tidig version. Det som fungerar i dag:

- Frontend (React) visar en knapp som anropar `/api/status/`.
- Anropet proxas av Vite till Django-backenden.
- Django svarar med ett JSON-meddelande som visar att kopplingen fungerar.
- Postgres är konfigurerad och körs i en container.

## Teknikstack

| Del | Teknik |
|---|---|
| Frontend | React 19, Vite, oxlint |
| Backend | Django 5.2, Django REST Framework, Python 3.11 |
| Databas | PostgreSQL 15 |
| AI-bibliotek (i `requirements.txt`) | LangChain, LangGraph, OpenAI, ChromaDB, pypdf, tiktoken |
| Infrastruktur | Docker, Docker Compose |

## Projektstruktur

```
.
├── docker-compose.yml
├── backend/
│   ├── Dockerfile
│   ├── manage.py
│   ├── requirements.txt
│   ├── .env                 # skapas lokalt (finns inte i Git)
│   └── core/
│       ├── settings.py
│       ├── urls.py
│       ├── views.py         # api_status-vyn
│       ├── asgi.py
│       └── wsgi.py
└── frontend/
    ├── Dockerfile
    ├── package.json
    ├── vite.config.js       # proxy: /api -> http://backend:8000
    └── src/
        ├── main.jsx
        └── App.jsx
```

## Kom igång

### Förutsättningar

- [Docker](https://docs.docker.com/get-docker/) och Docker Compose

### 1. Klona repot

```bash
git clone https://github.com/Zpangs/ai-project.git
cd ai-project
```

### 2. Skapa `backend/.env`

`docker-compose.yml` läser `./backend/.env`, så filen måste finnas innan du startar. Den får gärna vara tom i början. Här lägger du hemligheter och API-nycklar, till exempel:

```env
OPENAI_API_KEY=din-nyckel-här
```

> Lägg aldrig `.env` i Git. Kontrollera att den finns i `.gitignore`.

### 3. Starta allt

```bash
docker compose up --build
```

### 4. Kör databasmigreringar

I ett nytt terminalfönster:

```bash
docker compose exec backend python manage.py migrate
```

### 5. Öppna applikationen

| Tjänst | Adress |
|---|---|
| Frontend | http://localhost:3000 |
| Backend (API) | http://localhost:8000/api/status/ |
| Django admin | http://localhost:8000/admin/ |
| PostgreSQL | `localhost:5432` |

Klicka på **"Hämta data från Django"** i frontend. Om allt fungerar visas:

```json
{
  "message": "Kopplingen mellan React och Django fungerar!",
  "status": "success"
}
```

## Användbara kommandon

```bash
# Skapa en admin-användare
docker compose exec backend python manage.py createsuperuser

# Skapa en ny Django-app
docker compose exec backend python manage.py startapp <namn>

# Visa loggar
docker compose logs -f backend

# Stoppa allt
docker compose down

# Stoppa och ta bort databasdata (varning: raderar allt)
docker compose down -v
```

## API

| Metod | Endpoint | Beskrivning |
|---|---|---|
| GET | `/api/status/` | Returnerar ett JSON-svar som bekräftar att backend nås |

## Konfiguration

Databasinställningarna ligger i `backend/core/settings.py` och matchar `docker-compose.yml`:

| Inställning | Värde |
|---|---|
| Databas | `aidb` |
| Användare | `devuser` |
| Lösenord | `devpassword` |
| Värd | `db` |
| Port | `5432` |

## Att tänka på innan produktion

Nuvarande inställningar är endast avsedda för lokal utveckling:

- `SECRET_KEY` är hårdkodad i `settings.py`. Flytta den till en miljövariabel.
- `DEBUG = True` och `ALLOWED_HOSTS = ['*']` måste ändras.
- Databasuppgifterna är hårdkodade. Läs dem från miljövariabler.
- Dev-servrarna (`runserver` och `vite dev`) ska ersättas av en produktionsuppsättning (t.ex. gunicorn/uvicorn och en byggd frontend bakom en webbserver).
- `rest_framework` är installerat men ännu inte tillagt i `INSTALLED_APPS`.

## Nästa steg (förslag)

- [ ] Lägg till `rest_framework` i `INSTALLED_APPS` och bygg API:er med DRF
- [ ] Implementera AI-funktionalitet (t.ex. RAG med LangChain och ChromaDB)
- [ ] Lägg till autentisering
- [ ] Flytta konfiguration till miljövariabler
- [ ] Lägg till tester och CI

## Licens

Ingen licens angiven ännu. Lägg till en `LICENSE`-fil vid behov.
