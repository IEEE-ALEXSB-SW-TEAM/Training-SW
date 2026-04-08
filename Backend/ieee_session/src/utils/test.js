async function loopingfor() {
  for (let i = 0; i < 10000; i++) {
    console.log(i);
    //await new Promise((resolve) => setTimeout(resolve, 1000)); // Simulate async work
  }
}

loopingfor();
console.log("Done!");