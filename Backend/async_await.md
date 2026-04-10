# JavaScript Promises & Async/Await — Beginner Guide

## 📦 1. Basic Promise Syntax

```js
const promise = new Promise((resolve, reject) => {
    if (true) {
        resolve("Success ✅");
    } else {
        reject("Error ❌");
    }
});
```

---

## 🔗 2. Using a Promise (`then / catch`)

```js
promise
  .then(result => {
      console.log("Success:", result);
  })
  .catch(error => {
      console.log("Error:", error);
  });
```

---

## 🧪 3. Promise with `setTimeout`

```js
function getData() {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve("Data received 📦");
        }, 2000);
    });
}

console.log("Start");

getData().then(result => {
    console.log(result);
});

console.log("End");
```

### Output:

```
Start
End
Data received 📦
```

---

## 🔁 4. Promise Chaining

```js
Promise.resolve(5)
  .then(x => x * 2)
  .then(x => x + 1)
  .then(result => console.log(result));
```

### Output:

```
11
```

---

## ⚠️ 5. Common Mistake (Missing `return`)

```js
Promise.resolve(5)
  .then(x => {
      x * 2; // ❌ no return
  })
  .then(console.log);
```

### Output:

```
undefined
```

### ✅ Correct:

```js
.then(x => {
    return x * 2;
})
```

---

## ✨ 6. Async / Await Example

```js
function getFood() {
    return new Promise(resolve => {
        setTimeout(() => resolve("🍕 Pizza"), 2000);
    });
}

async function eat() {
    console.log("Ordering food...");

    const food = await getFood();

    console.log("Got:", food);
}

eat();
```

---

## ⚡ 7. `await` Does NOT Block JS

```js
console.log("Start");

async function test() {
    console.log("Inside");

    await new Promise(resolve => setTimeout(resolve, 1000));

    console.log("After await");
}

test();

console.log("End");
```

### Output:

```
Start
Inside
End
After await
```

---

## 🚀 8. Sequential vs Parallel

### ❌ Sequential (Slow)

```js
async function slow() {
    await new Promise(r => setTimeout(r, 1000));
    await new Promise(r => setTimeout(r, 1000));
}
```

---

### ✅ Parallel (Fast)

```js
async function fast() {
    await Promise.all([
        new Promise(r => setTimeout(r, 1000)),
        new Promise(r => setTimeout(r, 1000))
    ]);
}
```

---

## ❗ 9. Blocking Example (Important)

```js
async function bad() {
    for (let i = 0; i < 1e9; i++) {} // blocks!
}
```

👉 `async` does NOT make CPU work non-blocking

---

## 🧠 Final Cheat Sheet

```js
new Promise((resolve, reject) => {})

promise.then(fn)

promise.catch(fn)

Promise.resolve(value)

Promise.reject(error)

Promise.all([p1, p2])
```

---

## 🔥 Mental Model

* Promise = 📦 future value
* `resolve` → success
* `reject` → error
* `then` → handle success
* `catch` → handle error
* `async/await` → cleaner way to use promises

---
