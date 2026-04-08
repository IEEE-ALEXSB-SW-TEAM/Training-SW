# Backend Bootcamp Final Session Guide (Tick and Teach)

This guide is based on the current code state in this project and is designed for your last session.

---

## 1) Backend Concept Checklist (Tick While Teaching)

Use this as your master teaching tracker.

### A. Foundation Concepts

- [ ] Backend architecture overview (route -> controller -> service -> model -> database)
- [ ] Request/response lifecycle in Express
- [ ] HTTP methods and status codes (200, 201, 400, 401, 404, 409, 500)
- [ ] Environment variables and fail-fast startup
- [ ] Why health-check routes matter

### B. Node.js and Async Concepts

- [ ] Synchronous vs asynchronous execution
- [ ] Event loop basics (high-level)
- [ ] `Promise` basics
- [ ] `async/await` flow in real backend code
- [ ] Error propagation in async functions

### C. API Design Concepts

- [ ] REST endpoint naming conventions
- [ ] Input validation before business logic
- [ ] Consistent success response shape
- [ ] Consistent error response shape
- [ ] Clear API contracts between layers

### D. Auth and Security Concepts

- [ ] Password hashing and why plain passwords are forbidden
- [ ] Login credential verification flow
- [ ] JWT generation, payload, and expiry
- [ ] Bearer token pattern in Authorization header
- [ ] Protected route middleware concept

### E. Database Concepts

- [ ] Connection pool concept
- [ ] Parameterized queries (SQL injection protection)
- [ ] User lookup and creation flow
- [ ] Unique email constraint concept
- [ ] Service-model contract consistency

### F. Quality and Production Concepts

- [ ] Centralized error handling middleware
- [ ] Not-found route handling
- [ ] Logging basics and safe logs (no secrets)
- [ ] Config/import path consistency
- [ ] Manual and automated testing mindset

### G. Student Outcome Checklist

- [ ] Students can explain each backend layer responsibility
- [ ] Students can debug a broken import/config path
- [ ] Students can test success and failure flows manually
- [ ] Students can explain why async code is used in backend operations
- [ ] Students can explain full auth flow from register/login to protected endpoint

---

## 2) Current Code Reality (Important Before Teaching)

These points are true in the current project state and should be handled early:

- `server.js` uses `config/env.js`.
- `utils/generateToken.js` uses `config/env.js`.
- `models/user.model.js` still imports `config/config.js` (this path does not match current config file).
- `app.js` currently has only `/health` and no auth routes yet.
- `controllers/` and `routes/` are still missing implementation files.

Teach this as a real-world lesson: small path inconsistencies can break production.

---

## 3) Step-by-Step Build and Teach Plan (Each Step Includes Test + Take Care + Notes)

## Step 0: Start with what can already be tested

Teach:

- Always test the currently working surface before adding features.

Do:

1. Start server.
2. Call `GET /health`.

Test now:

- Expect status `200` and body like `{ status: 'OK!' }`.

Take care:

- If server does not start, check required env vars first.
- Make sure the running file is `server.js`.

Notes:

- This gives students quick confidence and a baseline.

---

## Step 1: Fix configuration import consistency first

Teach:

- Config source should be single and consistent across all modules.

Do:

1. Align model config import with existing config file (`env.js`).
2. Re-run server after alignment.

Test now:

- Server boots without module resolution errors.
- Any user model operation can load config without crash.

Take care:

- Do not keep mixed imports (`config.js` in one file and `env.js` in another) unless both truly exist by design.

Notes:

- Explain this as a common team bug after file renaming.

---

## Step 2: Explain and verify service-model contract

Teach:

- Contract means exact input/output shape agreement between layers.

Do:

1. Show `createUser({ name, email, passwordHash })` contract.
2. Show returned user shape `{ id, name, email }`.
3. Show how service uses that shape to generate token payload.

Test now:

- Register flow returns user with `id`, `name`, `email` and token.
- No undefined properties in token payload source.

Take care:

- Never assume model return shape without defining it.

Notes:

- This is one of the most important backend design concepts for juniors.

---

## Step 3: Build controller layer

Teach:

- Controllers are HTTP adapters, not business logic containers.

Do:

1. Create auth controller file.
2. Add `register` and `login` controller handlers.
3. Forward errors to centralized error handler (`next(error)`).

Test now:

- With temporary route wiring, valid register returns `201`.
- Valid login returns `200`.

Take care:

- Keep controller thin.
- Do not expose `password_hash` in response.

Notes:

- Show students side-by-side difference between controller and service responsibilities.

---

## Step 4: Build routes and mount in app

Teach:

- Routes map URL + method to controller handlers.

Do:

1. Create auth routes file.
2. Add `POST /api/auth/register`.
3. Add `POST /api/auth/login`.
4. Mount routes in `app.js`.
5. Add `express.json()` in `app.js`.

Test now:

- `POST /api/auth/register` with valid payload -> `201`.
- `POST /api/auth/login` with valid payload -> `200`.

Take care:

- Without `express.json()`, request body will be undefined.

Notes:

- Ask students to intentionally remove `express.json()` once and observe failure.

---

## Step 5: Add input validation middleware

Teach:

- Validation runs before service logic to protect system boundaries.

Do:

1. Add validation rules for register (`name`, `email`, `password`).
2. Add validation rules for login (`email`, `password`).
3. Attach validator middleware at route level.

Test now:

- Register missing name -> `400`.
- Register bad email -> `400`.
- Login missing password -> `400`.

Take care:

- Keep validation errors readable and consistent.

Notes:

- Students should learn to test invalid payloads first, not only happy path.

---

## Step 6: Add centralized error handling

Teach:

- Throw in service, format in one error middleware.

Do:

1. Add not-found middleware.
2. Add global error middleware at the end of middleware chain.
3. Standardize error response shape.

Test now:

- Duplicate email register -> `409`.
- Wrong password login -> `401`.
- Unknown route -> `404`.

Take care:

- Middleware order matters: routes first, then not-found, then error handler.

Notes:

- This is where students usually understand Express middleware flow deeply.

---

## Step 7: Add JWT auth middleware and protected route

Teach:

- Auth middleware verifies token once and passes user context to controllers.

Do:

1. Create auth middleware to parse `Authorization: Bearer <token>`.
2. Verify token signature and expiry.
3. Attach decoded user data to request.
4. Create `GET /api/auth/me` protected route.

Test now:

- `/api/auth/me` no token -> `401`.
- `/api/auth/me` invalid token -> `401`.
- `/api/auth/me` valid token -> `200` and user data.

Take care:

- Handle missing header, malformed header, and expired token separately for clearer learning.

Notes:

- Show how one middleware can protect many routes.

---

## Step 8: Security mini-hardening

Teach:

- Secure defaults are part of backend professionalism.

Do:

1. Ensure no response returns password hash.
2. Discuss minimum password policy.
3. Add DB unique email constraint if not present.
4. Keep JWT secret only in env.

Test now:

- Response bodies never include password hash.
- Duplicate email path consistently returns conflict behavior.

Take care:

- Do not log tokens or raw credentials.

Notes:

- Mention that security is a process, not a one-time checkbox.

---

## Step 9: Final end-to-end demo script

Teach:

- End-to-end testing validates integration between all layers.

Do and test in this exact order:

1. `GET /health` -> `200`
2. `POST /api/auth/register` invalid payload -> `400`
3. `POST /api/auth/register` valid payload -> `201` + token
4. `POST /api/auth/register` duplicate email -> `409`
5. `POST /api/auth/login` wrong password -> `401`
6. `POST /api/auth/login` valid credentials -> `200` + token
7. `GET /api/auth/me` without token -> `401`
8. `GET /api/auth/me` with token -> `200`

Take care:

- Keep one known test user for consistent demos.

Notes:

- Ask students to explain which layer generated each response.

---

## 4) Async vs Sync Explanation Module (Use During Session)

## 4.1 Synchronous Example (Blocking)

```js
function syncTask() {
	console.log("Start sync");
	for (let i = 0; i < 1e9; i++) {
		// busy loop blocks
	}
	console.log("End sync");
}

console.log("Before");
syncTask();
console.log("After");
```

Teach:

- The thread is blocked until loop completes.

Test now:

- Observe `After` appears only after `End sync`.

Take care:

- Do not use blocking loops in real request handlers.

Notes:

- Connect this to why backend scalability suffers with blocking code.

## 4.2 Asynchronous Example (Non-Blocking Scheduling)

```js
function asyncTask() {
	console.log("Start async");
	setTimeout(() => {
		console.log("Async done later");
	}, 1000);
	console.log("End async function");
}

console.log("Before");
asyncTask();
console.log("After");
```

Teach:

- Timer callback runs later; flow continues immediately.

Test now:

- Observe `After` appears before `Async done later`.

Take care:

- Asynchronous does not mean parallel CPU execution by default.

Notes:

- This helps explain I/O behavior in Node.js.

## 4.3 Async/Await Example (Backend Style)

```js
function fakeDbCall() {
	return new Promise((resolve) => {
		setTimeout(() => resolve("DB result"), 1000);
	});
}

async function run() {
	console.log("Before await");
	const result = await fakeDbCall();
	console.log(result);
	console.log("After await");
}

run();
console.log("Process can continue serving other events");
```

Teach:

- `await` pauses inside this async function until the promise settles.

Test now:

- Observe order of logs and discuss why it happens.

Take care:

- Always wrap awaited calls in proper error handling in backend paths.

Notes:

- Directly map this to `hashPassword`, `findByEmail`, and `createUser` calls.

---

## 5) Last Session Ready-to-Run Testing Checklist

Tick during final QA before ending bootcamp.

- [ ] Server starts cleanly with valid env.
- [ ] `/health` returns 200.
- [ ] Config import paths are consistent.
- [ ] Register valid flow works.
- [ ] Register duplicate flow returns 409.
- [ ] Login valid flow works.
- [ ] Login invalid flow returns 401.
- [ ] Validation errors return 400.
- [ ] Protected route rejects missing token.
- [ ] Protected route accepts valid token.
- [ ] Error response shape is consistent.
- [ ] Success response shape is consistent.
- [ ] No password hash leakage in responses.
- [ ] Students can explain sync vs async with example.
- [ ] Students can trace request through backend layers.

