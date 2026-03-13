const express = require("express");
const mongoose = require("mongoose");


const app = express();
const PORT = 3000;

mongoose.connect("mongodb://mongodb:27017/devopsdb")
	.then(() => {
		console.log("MongoDB connected");
	})
	.catch((err) => {
		console.error(err);
	});
app.get("/", (req, res)=>{
	res.send("Hello from Node Backend connected to MongoDB");
});

app.listen(PORT, ()=>{
	console.log("Server running on port 3000");
});
