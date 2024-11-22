const express = require("express");
const cors = require("cors");
const path = require("path");

const app = express();
const PORT = 8078;

app.use(cors());
app.use(express.static(path.join(__dirname, "assets"))); 

const owner = {
  name: "Spikey Sanju",
  bio: "Developer & Pet Lover",
  imageUrl: "owner.png", 
};

const dogs = [
  {
    id: 0,
    name: "Hachiko",
    age: 3.5,
    gender: "Male",
    color: "Brown",
    weight: 12.9,
    location: "389m away",
    imageUrl: "orange_dog.png", 
    description:
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    owner,
  },
  {
    id: 1,
    name: "Skooby Doo",
    age: 3.5,
    gender: "Male",
    color: "Gold",
    weight: 12.4,
    location: "412m away",
    imageUrl: "blue_dog.png", 
    description:
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    owner,
  },
  {
    id: 2,
    name: "Miss Agnes",
    age: 3.5,
    gender: "Female",
    color: "White",
    weight: 9.6,
    location: "879m away",
    imageUrl: "red_dog.png", 
    description:
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    owner,
  },
  {
    id: 3,
    name: "Cyrus",
    age: 3.5,
    gender: "Male",
    color: "Black",
    weight: 8.2,
    location: "672m away",
    imageUrl: "yellow_dog.png", 
    description:
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    owner,
  },
  {
    id: 4,
    name: "Shelby",
    age: 3.5,
    gender: "Female",
    color: "Choco",
    weight: 14.9,
    location: "982m away",
    imageUrl: "white_dog.png", 
    description:
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    owner,
  },
];

app.get("/dogs", (req, res) => {
  res.json(dogs);
});

app.get("/dogs/:id", (req, res) => {
  const dogId = parseInt(req.params.id);
  const dog = dogs.find((d) => d.id === dogId);

  if (dog) {
    res.json(dog);
  } else {
    res.status(404).json({ error: "Dog not found" });
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
