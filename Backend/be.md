# 🚀 Backend Engineering 

> Goal: By the end of this session, you will build a real backend server with authentication and understand *why* everything works, not just how.

---

# 1️⃣ What Is Backend?

## 🧠 Concept First

Backend is the **brain of the application**.

It is responsible for:

* Storing data
* Applying business rules
* Authenticating users
* Protecting sensitive information
* Communicating with databases and services

It runs on a **server**, not in the browser.

---

## 🏗 Real Example: Instagram Login

When you press “Login”:

1. Frontend collects email & password
2. Sends them to backend
3. Backend:

   * Finds user in database
   * Checks password
   * Generates token
   * Sends response

The frontend **never sees the database directly**.

---

## ❓ Questions

1. Why should frontend NOT access the database directly?
2. What could go wrong if passwords were checked in frontend?
3. Can backend exist without frontend?

---

### Q1: Why should frontend NOT access the database directly?

Because:

1. **Security**

   * Anyone can inspect frontend code.
   * If DB credentials are in frontend → they are exposed.
   * Attackers could delete or steal all data.

2. **Business Logic Protection**

   * You don’t want users deciding:

     * product price
     * discount rules
     * admin privileges

3. **Validation & Control**

   * Backend ensures:

     * Data format is correct
     * User is allowed
     * Rules are enforced

4. **Scalability**

   * Backend controls:

     * rate limiting
     * caching
     * logging
     * monitoring

> Frontend is public. Backend is controlled.

---

### Q2: What could go wrong if passwords were checked in frontend?

Everything.

Example:
If login logic is in frontend:

```js
if(password === "1234")
```

Anyone can:

* Open DevTools
* Read the code
* See the logic
* Bypass it

Even worse:
You would need to send all users' passwords to the browser to compare.

That means:

* You leaked your entire database.

Authentication must always happen on the server.

---

### Q3: Can backend exist without frontend?

Yes.

Examples:

* Mobile apps use backend.
* Another backend can call your backend.
* IoT devices use backend APIs.
* CLI apps use backend APIs.

Frontend is just one type of client.

---


---

# 🧠 Final Mental Model

Backend responsibilities:

1. Validate input
2. Authenticate user
3. Authorize action
4. Process business logic
5. Interact with database
6. Return proper response

---


---

## 🚨 Common Mistake

> Thinking backend = database.

No.
Backend is the **logic layer** that talks to the database.

---

# 2️⃣ Client–Server Architecture

## 🎯 Core Idea

Everything works using:

```
Client  --->  Server
        <---  
```

---

## 🧾 What Is a Client?

* Browser
* Mobile app
* Postman
* Another backend

It **sends requests**.

---

## 🏢 What Is a Server?

* A machine running backend code
* Listens for requests
* Processes logic
* Sends responses

---

## 🔄 Request → Response Lifecycle

1. Client sends HTTP request
2. Server receives it
3. Server processes it
4. Server returns HTTP response

---

## 📦 Example

Request:

```
GET /users
```

Response:

```json
[
  { "id": 1, "name": "Ahmed" }
]
```

---

## ❓ Questions

1. What happens if server crashes?
2. Who starts the communication — client or server?
3. Can one server serve multiple clients?


---


### Q1: What happens if server crashes?

Clients get:

* No response
* Or 500 error
* Or connection refused

In production:

* We use load balancers
* Multiple server instances
* Auto-restart systems (PM2, Docker, Kubernetes)

Backend reliability is critical.

---

### Q2: Who starts communication — client or server?

Always the client.

HTTP is request-response.

Server waits.
Client initiates.

(Unless using WebSockets, which is advanced topic.)

---

### Q3: Can one server serve multiple clients?

Yes.

That’s the whole idea.

One backend can serve:

* 10 users
* 10,000 users
* 10 million users

Concurrency and scaling become important here.


---

# 3️⃣ What Is an API?

## 🧠 Definition

API = Application Programming Interface

It is a **contract** between systems.

It defines:

* What URL?
* What method?
* What input?
* What output?

---

## 📍 Endpoint Structure

```
METHOD /route
```

Examples:

```
GET    /users
POST   /login
DELETE /users/5
```

---

## 📄 Why JSON?

Backend and frontend communicate using JSON because:

* It is lightweight
* Easy to parse
* Language independent

Example:

```json
{
  "email": "test@gmail.com",
  "password": "123456"
}
```

---

## ❓ Questions

1. Is API only for frontend-backend?
2. Can backend talk to another backend using API?
3. What happens if frontend sends wrong JSON format?

---


### Q1: Is API only for frontend-backend?

No.

APIs are everywhere.

Examples:

* Backend → Payment provider
* Backend → Google Maps
* Microservice → Microservice
* Backend → AI service

API = communication contract between systems.

---

### Q2: Can backend talk to another backend using API?

Yes.

Example:
Your app → Stripe API → Payment processed.

That is backend-to-backend communication.

---

### Q3: What happens if frontend sends wrong JSON format?

Server should return:

```http
400 Bad Request
```

Because:

* Client made invalid request.

If server crashes because of bad JSON → that’s bad backend design.


---

# 4️⃣ HTTP Methods Deep Understanding

HTTP is the protocol for communication.

---

## 1️⃣ GET

Used to **read data**

Properties:

* No body
* Should not modify data

Example:

```
GET /products
```

---

## 2️⃣ POST

Used to **create data**

Example:

```
POST /users
```

With body:

```json
{
  "name": "Ali"
}
```

---

## 3️⃣ PUT

Used to replace full object.

---

## 4️⃣ PATCH

Used to update partially.

---

## 5️⃣ DELETE

Used to remove resource.

---

## 🧠 REST Thinking

If you have:

```
/users
```

Then:

| Action        | Method         |
| ------------- | -------------- |
| Get all users | GET            |
| Get one user  | GET /users/:id |
| Create user   | POST           |
| Update user   | PATCH          |
| Delete user   | DELETE         |

---

## ❓ Questions

1. Should login be GET or POST? Why?
2. Can GET change database?
3. Why is DELETE not POST?

---

### Q1: Should login be GET or POST? Why?

POST.

Because:

* It sends sensitive data (password).
* GET exposes data in URL.
* GET is cached sometimes.
* GET should not change server state.

Login is secure action → use POST.

---

### Q2: Can GET change database?

Technically yes.
But it SHOULD NOT.

By REST convention:
GET must be safe and read-only.

If GET modifies data → bad design.

---

### Q3: Why is DELETE not POST?

Because REST principles map actions to methods.

POST = create
DELETE = remove

Using POST for everything makes API unclear and harder to maintain.




---

# 5️⃣ HTTP Status Codes (More Than Numbers)

| Code | Meaning                       |
| ---- | ----------------------------- |
| 200  | Success                       |
| 201  | Created                       |
| 400  | Bad input                     |
| 401  | Not authenticated             |
| 403  | Authenticated but not allowed |
| 404  | Not found                     |
| 500  | Server error                  |

---

## 🧠 Difference Between 401 and 403

401 → Who are you?
403 → I know you. But you are not allowed.

---

## ❓ Questions

1. If login fails, should it be 400 or 401?
2. When do we return 500?

---

### Q1: If login fails, should it be 400 or 401?

401.

Because:

* Credentials are wrong.
* Authentication failed.

400 is for:

* Missing fields
* Invalid input format

---

### Q2: When do we return 500?

When the server has an unexpected internal error.

Examples:

* Database crashed
* Unhandled exception
* Null reference error

Never return 500 for user mistakes.

---

# 6️⃣ Postman - Testing Backend

Postman simulates a client.

You can:

* Select method
* Add URL
* Add body
* Add headers
* Inspect response

---

## 🔍 Workshop

Now let's try a real API.
Search for a free API and try Postman to GET any data.


---

## ❓ Questions

1. Why do backend engineers use Postman?
2. Can frontend replace Postman?

---
### Q1: Why do backend engineers use Postman?

Because:

* We test APIs without frontend.
* Faster debugging.
* Clear request/response visibility.
* Helps isolate frontend vs backend issues.

It removes frontend complexity.

---

### Q2: Can frontend replace Postman?

Yes, but:

Frontend adds:

* UI bugs
* State issues
* CORS issues

Postman is clean and direct.

---

# 7️⃣ Build Your Own Server 

---

## Setup

```bash
npm init -y
npm install express jsonwebtoken
```

This will be our general file structure for backend

```
backend-auth-project/
│
├── src/
│   ├── config/
│   │   └── env.js
│   │
│   ├── controllers/
│   │   ├── auth.controller.js
│   │   └── user.controller.js
│   │
│   ├── middlewares/
│   │   ├── auth.middleware.js
│   │   ├── error.middleware.js
│   │   └── validation.middleware.js
│   │
│   ├── routes/
│   │   ├── auth.routes.js
│   │   └── user.routes.js
│   │
│   ├── services/
│   │   └── auth.service.js
│   │
│   ├── models/
│   │   └── user.model.js
│   │
│   ├── utils/
│   │   ├── generateToken.js
│   │   └── hashPassword.js
│   │
│   ├── app.js
│   └── server.js
│
├── .env
├── package.json
└── README.md
```
---



---
Let's have some questions networks-related before continuing.

## ❓ Questions

1. What is a port?
2. Can two servers run on same port?
3. What happens if no route matches?

---

### Q1: What is a port?

A port is a communication channel on a machine.

Example:

* Port 80 → HTTP
* Port 443 → HTTPS
* Port 3000 → Development server

IP = building address
Port = apartment number

---

### Q2: Can two servers run on same port?

No.

Only one process can listen to a port at a time.

Otherwise → port conflict error.

---

### Q3: What happens if no route matches?

Server returns:

```http
404 Not Found
```

Because route does not exist.


---

# 8️⃣ Database

Now, we move to the data part in backend:

---

## 🧠 SQL vs NoSQL

### 🎯 Core Difference

| SQL                | NoSQL                         |
| ------------------ | ----------------------------- |
| Structured         | Flexible                      |
| Tables             | Documents / Key-Value / Graph |
| Fixed schema       | Dynamic schema                |
| Strong consistency | Often flexible consistency    |

---

## 🏗 1️⃣ SQL (Relational Databases)

### Examples

* MySQL
* PostgreSQL
* Microsoft SQL Server

---

### 📊 Structure

Data stored in **tables**:

```sql
users
--------------------------------
id | email        | password
1  | a@test.com   | hash123
```

Schema must be defined first:

```sql
CREATE TABLE users (
  id INT PRIMARY KEY,
  email VARCHAR(255) UNIQUE
);
```

You cannot suddenly insert random fields.

---

### ✅ Strengths of SQL

1. Strong relationships (JOINs)
2. ACID transactions (very important for money)
3. Data integrity
4. Mature ecosystem
5. Complex queries are powerful

---

### 🧠 When SQL Is Best

* Banking systems
* E-commerce
* Inventory systems
* Systems with strong relationships
* When consistency matters more than flexibility

---

## 📦 2️⃣ NoSQL (Non-Relational Databases)

### Examples

* MongoDB
* Redis
* Cassandra

---

### 📄 Structure (Document Example)

```json
{
  "_id": 1,
  "email": "a@test.com",
  "profile": {
    "age": 22,
    "hobbies": ["football", "coding"]
  }
}
```

No strict schema required.

You can store different shapes per document.

---

### ✅ Strengths of NoSQL

1. Flexible schema
2. Easy horizontal scaling
3. Good for large distributed systems
4. Faster development in early stages

---

### 🧠 When NoSQL Is Best

* Rapid prototyping
* Analytics systems
* Real-time feeds
* Logging systems
* Highly scalable distributed systems

---

## ⚖️ The Real Difference 

### 🔐 Consistency

SQL → Strong consistency by default
NoSQL → Often eventual consistency

Meaning:

SQL guarantees correctness immediately.

NoSQL may prioritize availability & performance.

---

### 📈 Scaling

SQL → Vertical scaling (strong machine)
NoSQL → Horizontal scaling (many machines)

Modern SQL databases can scale horizontally too — but traditionally NoSQL was designed for that.

---

## 🧠 ACID vs BASE

SQL = ACID

* Atomicity
* Consistency
* Isolation
* Durability

NoSQL = Often BASE

* Basically Available
* Soft state
* Eventually consistent

---

## 🚨 Common Beginner Mistake

> “MongoDB is modern so it’s better.”

Wrong.

Database choice depends on:

* Data relationships
* Consistency requirements
* Scale needs
* Query complexity
* Team expertise

There is no “better”.
There is only “better for this problem”.


---

## 🧠 Deep Thinking Questions (You Can Ask)

1. Can you build Instagram with SQL?
2. Can you build a banking system with NoSQL?
5. When does flexibility become chaos?

---

# 🏁 Final Engineering Advice

Early-stage startup?
→ NoSQL can be convenient.

Finance system?
→ SQL almost always.

Large-scale distributed logs?
→ NoSQL.

User accounts & authentication?
→ SQL is usually cleaner.


---

# 9️⃣ Authentication vs Authorization

## 🔐 Authentication

Verifying identity.

Example:

* Email & password
* Token

---

## 🛡 Authorization

Checking permissions.

Example:

* Only admin can delete users

---

## ❓ Questions

1. Can someone be authenticated but not authorized?
2. Can someone be authorized without authentication?

---

### Q1: Can someone be authenticated but not authorized?

Yes.

Example:

* Logged-in user tries to delete another user.
* Server responds 403.

Authenticated ≠ allowed.

---

### Q2: Can someone be authorized without authentication?

No.

You must know who they are before checking permissions.

Authorization requires identity first.


---

# 🔟 JWT

**JWT (JSON Web Token)** is a **signed token used for authentication**.

## Structure

```
header.payload.signature
```

Example payload:

```json
{
  "id": 5,
  "exp": 1712345678
}
```

## How it works

1. User logs in.
2. Server creates a JWT containing user data.
3. Server **signs it with a secret key**.
4. Client sends the token with each request.

```
Authorization: Bearer <token>
```

## Why it’s secure

If someone changes the payload (like `id:5 → id:1`),
the **signature becomes invalid**, so the server rejects it.

## Key idea

JWT lets the server **verify identity without storing sessions**.

**In one sentence:**
JWT = **a signed identity card the client carries with every request.** 🔑


---

## ❓ Questions

1. Where is JWT stored?
2. What happens if secret key leaks?

---

### Q1: Where is JWT stored?

Usually:

* LocalStorage
* HTTP-only cookies

Better practice:
HTTP-only secure cookies.

Why?
To reduce XSS attacks.

---

### Q2: What happens if secret key leaks?

Game over.

Attackers can:

* Create fake tokens
* Impersonate users
* Access protected routes

Secret must be:

* Hidden
* In environment variables
* Rotated if leaked




---

# 🔄 Final Flow Diagram

1. Register
2. Login
3. Receive token
4. Send token in header
5. Access protected route

Header format:

```
Authorization: Bearer TOKEN_HERE
```

---

# 🧠 Deep Thinking Section

1. What if token expires?
2. What if attacker steals token?
3. Why do we use HTTPS?
4. Why should passwords be hashed?

---

### Q1: What if token expires?

Server rejects it.
Client must:

* Login again
  OR
* Use refresh token system

---

### Q2: What if attacker steals token?

They can act as user until token expires.

Mitigations:

* Short expiration
* HTTPS
* HTTP-only cookies
* Refresh token rotation

---

### Q3: Why do we use HTTPS?

Without HTTPS:

* Data travels in plain text.
* Passwords can be intercepted.

HTTPS encrypts traffic.

---

### Q4: Why should passwords be hashed?

Because if database leaks:

Without hashing:

* All passwords exposed.

With hashing:

* Attacker sees only hashed values.
* Hard to reverse.

We use bcrypt because:

* It is slow (harder to brute force).


---

# 🏁 What You Built

* REST API
* Authentication system
* Middleware
* Token-based access control
* Understanding of backend architecture


---

# 🔜 What’s Next?

In this session, you built a **real backend server with authentication** and learned the core concepts behind backend systems.

You now understand:

* Client–Server architecture
* REST APIs
* HTTP methods and status codes
* Express server
* Database basics
* Password hashing
* JWT authentication
* Middleware
* Backend project structure

However, real-world backend systems go far beyond this.

The next step is learning how to build **production-grade systems**.

---

## 1️⃣ Input Validation

One of the biggest security rules in backend engineering is:

> **Never trust client input.**

Clients can send:

* invalid data
* malformed JSON
* malicious input

Example request:

```json
{
  "email": "not-an-email",
  "password": ""
}
```

Without validation, this could break your system.

Backend engineers use validation libraries such as:

* Zod
* Joi
* Yup

Validation ensures:

* correct data types
* required fields
* safe input

---

## 2️⃣ Authorization (Permissions)

Authentication answers:

```
Who are you?
```

Authorization answers:

```
What are you allowed to do?
```

Example:

| Role  | Permission   |
| ----- | ------------ |
| User  | Read profile |
| Admin | Delete users |

Example protected route:

```
DELETE /users/:id
```

Only admins should be allowed to perform this action.

---

## 3️⃣ API Documentation

When APIs grow, other developers need to understand how to use them.

APIs are documented using tools such as:

* Swagger
* OpenAPI

Example endpoint documentation:

```
POST /auth/login
Body:
{
  email
  password
}

Response:
{
  token
}
```

Documentation makes APIs easier to maintain and integrate.

---

## 4️⃣ Logging & Monitoring

Backend engineers must be able to **observe system behavior**.

Logging helps answer questions like:

* Why did the request fail?
* When did the server crash?
* Which endpoint is slow?

In production, systems use tools like:

* Winston
* Datadog
* Grafana

---

## 5️⃣ Rate Limiting

Public APIs must protect against abuse.

Example attack:

```
Brute force login attempts
```

Solution:

```
Rate limiting
```

Example rule:

```
Maximum 100 requests per minute
```

This prevents attackers from overwhelming the server.

---

## 6️⃣ System Design & Scaling

As applications grow, backend systems must handle:

* millions of users
* large datasets
* high traffic

This introduces advanced topics such as:

* caching
* load balancing
* distributed systems
* microservices

These concepts are essential for building **large-scale platforms**.

---

## 🧠 Final Thought

Backend engineering is not just about writing endpoints.

It is about designing systems that are:

* secure
* reliable
* scalable
* maintainable

The fundamentals you learned today are the same foundations used by engineers building systems at companies like:

* Netflix
* Amazon
* Google
* Meta

Master the fundamentals, and everything else in backend engineering will build on top of them.

---



