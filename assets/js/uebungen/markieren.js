var mark_button = document.getElementById("mark_button");
var solution_button = document.getElementById("sol_button");
var reset_button = document.getElementById("res_button");
var original_text

window.addEventListener("DOMContentLoaded", function () {
    original_text = document.getElementById("markable_text").innerHTML;
});

function checkUserMarkings() {
    var user_markings = document.querySelectorAll(".marked");
    for (var i = 0; i < user_markings.length; i++) {
        if (user_markings[i].parentElement.classList.contains('correct_marker')) {
            user_markings[i].className = "marked_correct";
        } else {
            user_markings[i].className = "marked_false";
        }
    }
}

function showCorrectMarkings() {
    var correct_markings = document.querySelectorAll(".correct_marker");
    for (var j = 0; j < correct_markings.length; j++) {
        if (correct_markings[j].parentElement.classList.contains('marked_false')) {
            correct_markings[j].className = "marked_correct";
        } else {
            correct_markings[j].className = "unmarked_correct";
        }
    }
}

solution_button.addEventListener('click', function validate() {
    checkUserMarkings();
    showCorrectMarkings();
    mark_button.disabled = true;
    mark_button.style.visibility = "hidden";
    solution_button.disabled = true;
    solution_button.style.visibility = "hidden";
    solution.style.visibility = "visible";
});

reset_button.addEventListener('click', function reset() {
    resetText();
    mark_button.disabled = false;
    mark_button.style.visibility = "visible";
    solution_button.disabled = false;
    solution_button.style.visibility = "visible";
    solution.style.visibility = "hidden";
});

function resetText() {
    var text = document.getElementById("markable_text");
    text.innerHTML = original_text;
}

mark_button.addEventListener('click', function mark () {
    var range = document.getSelection().getRangeAt(0);
    var span = document.createElement('span');
    span.className = 'marked';
    span.appendChild(range.extractContents());
    range.insertNode(span);
    document.getSelection().empty();
});