const hamBurger = document.querySelector(".toggle-btn");

hamBurger.addEventListener("click", function () {
  document.querySelector("#sidebar").classList.toggle("expand");
});
const javaButton = document.getElementById('java');
const testingButton = document.getElementById('testing');
const netButton = document.getElementById('net')
const databaseButton = document.getElementById('db')
const message = document.getElementById('message');

javaButton.addEventListener('click', () => {
  message.textContent = 'You Have Selected Java Option';
});

testingButton.addEventListener('click', () => {
  message.textContent = 'You Have Selected Testing Option';
});

databaseButton.addEventListener('click', () => {
  message.textContent = 'You Have Selected DataBase Option';
});


netButton.addEventListener('click', () => {
  message.textContent = 'You Have Selected .NET Option ';
});

