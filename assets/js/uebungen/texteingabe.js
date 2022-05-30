var solution_button = document.getElementById("sol_button");
var reset_button = document.getElementById("res_button");
var input_field = document.getElementById('input_field');

solution_button.addEventListener('click', function validate() {
    solution_button.disabled = true;
    solution_button.style.visibility = "hidden";
    solution.style.visibility = "visible";
});

reset_button.addEventListener('click', function reset() {
    solution_button.disabled = false;
    solution_button.style.visibility = "visible";
    solution.style.visibility = "hidden";
    input_field.value = "";
});