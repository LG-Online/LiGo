var solution_button = document.getElementById("sol_button");
var reset_button = document.getElementById("res_button");
var radio_buttons = document.querySelectorAll("input[type=radio]");
var option_pool = document.getElementById("option_pool");
var solution_pool = document.getElementById("solution_pool");
var feedback = document.getElementById("mc_feedback");
var solution = document.getElementById("mc_solution");

solution_button.addEventListener('click', function validate() {
    var checked_option = document.querySelector('input[name = "mc"]:checked');
    if (checked_option != null) {
        showFeedbackAndColor(checked_option);
        showSolution(checked_option, solution_pool);
    } else {
        feedback.innerHTML = "Bitte wählen Sie zuerst eine Antwort aus!";
        option_pool.classList.add("wrong");
    }
    disableButtons();
    solution_button.disabled = true;
    solution_button.style.visibility = "hidden";
});

function showFeedbackAndColor(checked_option) {
    if (checked_option.value === 'true') {
        feedback.innerHTML = "Die gewählte Antwort ist richtig!";
        feedback.classList.add("right");
        checked_option.parentElement.classList.add("right");
    } else {
        feedback.innerHTML = "Die gewählte Antwort ist falsch!";
        feedback.classList.add("wrong");
        checked_option.parentElement.classList.add("wrong");
    }
}

function showSolution(checked_option, solution_pool) {
    for (var j = 0; j < solution_pool.children.length; j++) {
        if (solution_pool.children[j].className === checked_option.id) {
            solution.innerHTML = solution_pool.children[j].innerHTML;
        }
    }
}

reset_button.addEventListener('click', function reset() {
    clear();
    var checked_option = document.querySelector('input[name = "mc"]:checked');
    if (checked_option != null) {
        document.querySelector('input[name="mc"]:checked').checked = false;
    };
});

for (var i = 0, num_rb = radio_buttons.length; i < num_rb; i++) {
    radio_buttons[i].onclick = clear;
}

function disableButtons(){
    for (var i = 0, num_rb = radio_buttons.length; i < num_rb; i++) {
        radio_buttons[i].disabled = true;
    }
}

function enableButtons(){
    for (var i = 0, num_rb = radio_buttons.length; i < num_rb; i++) {
        radio_buttons[i].disabled = false;
    }
}

function clear() {
    var mc_options = document.getElementsByClassName('mc_option');
    for (var k = 0; k < mc_options.length; k++) {
        mc_options[k].classList.remove("right", "wrong");
    }
    enableButtons();
    feedback.innerHTML = "";
    solution.innerHTML = "";
    solution_button.disabled = false;
    solution_button.style.visibility = "visible";
    feedback.classList.remove("right");
    feedback.classList.remove("wrong");
    option_pool.classList.remove("wrong");
}