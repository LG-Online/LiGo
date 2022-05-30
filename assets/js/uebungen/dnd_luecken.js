var solution_button = document.getElementById("sol_button");
var reset_button = document.getElementById("res_button");
var drop_areas = document.getElementById("drop_areas");
var draggable_items = document.getElementById("draggable_items");
var feedback;
var draggable_items_complete;
var num_items_total;
var num_items_correct = 0;

window.addEventListener("DOMContentLoaded", function () {
    num_items_total = document.getElementById("draggable_items").childElementCount;
    draggable_items_complete = document.getElementById("draggable_items").innerHTML;
    var draggable_items_height = document.getElementById("draggable_items_container").clientHeight;
    
    var draggable_items_container = document.getElementById("draggable_items_container");
    draggable_items_container.style.height = draggable_items_height + "px";
});

function allowDrop(ev) {
    ev.preventDefault();
}

function drag(ev) {
    ev.dataTransfer.setData("text", ev.target.id);
}

function drop(ev, el) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("text");
    el.appendChild(document.getElementById(data));
    /*  
    var src = document.getElementById (ev.dataTransfer.getData ("src"));
    var srcParent = src.parentNode;
    var tgt = ev.currentTarget.firstElementChild;
  
    ev.currentTarget.replaceChild (src, tgt);
    srcParent.appendChild (tgt);
    */
    
    /*
    if (document.getElementById("drop_area_1").firstChild) {
        document.getElementById("drop_area_1").removeAttribute("ondragover");
    }
    */
}

solution_button.addEventListener('click', function validate() {
    for (var j = 1; j <= drop_areas.children.length; j++) {
        var drop_area = document.getElementById("drop_area_" + j);
        colorize(drop_area);
    }
    showFeedback(num_items_correct, num_items_total);
    solution_button.disabled = true;
    solution_button.style.visibility = "hidden";
    solution.style.visibility = "visible";
});

function colorize(drop_area) {
    for (var i = 0; i < drop_area.children.length; i++) {
        if (drop_area.children[i].className == drop_area.id) {
            drop_area.children[i].classList.add("correct");
            num_items_correct++;
        } else {
            drop_area.children[i].classList.add("wrong");
        }
    }
    draggable_items.classList.add("wrong");
}

function showFeedback(num_items_correct, num_items_total) {
    if (document.getElementById("dnd_feedback")) {
        feedback = document.getElementById("dnd_feedback");
        feedback.innerHTML = num_items_correct + " von " + num_items_total + " Begriffen korrekt zugeordnet. Musterlösung:";
    };
    if (document.getElementById("gaps_feedback")) {
        var num_gaps_total = document.querySelectorAll('.gaps').length;
        feedback = document.getElementById("gaps_feedback");
        feedback.innerHTML = num_items_correct + " von " + num_gaps_total + " Lücken korrekt gefüllt. Erläuterung:";
    };
}

reset_button.addEventListener('click', function reset() {
    draggable_items.innerHTML = draggable_items_complete;
    draggable_items.classList.remove("wrong");
    clearDropAreas();
    feedback.innerHTML = "";
    num_items_correct = 0;
    solution_button.style.visibility = "visible";
    solution.style.visibility = "hidden";
    solution_button.disabled = false;
});

function clearDropAreas() {
    for (var i = 0; i < drop_areas.children.length; i++) {
        drop_areas.children[i].innerHTML = "";
    }
}

