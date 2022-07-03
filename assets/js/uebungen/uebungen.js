/* VORBEREITUNGEN */

/* Iterieren über alle Übungen auf der Seite */
var exercises = document.querySelectorAll('.exercise');
for (var i = 0; i < exercises.length; i++){
    var current_exercise = exercises[i];
    check_exercise(current_exercise);
}

/* Festlegen der Nummer und Überprüfen des Typs der aktuellen Übung */
function check_exercise(current_exercise){
    var ex_nr = i+1;
    if (exercises[i].classList.contains("mc")){
        mc_exercise(ex_nr);
    } else if (exercises[i].classList.contains("text")){
        text_exercise(ex_nr);
    } else if (exercises[i].classList.contains("marker")){
        marker_exercise(ex_nr);
    } else if (exercises[i].classList.contains("gaps")){
        luecken_exercise(ex_nr);
    } else if (exercises[i].classList.contains("dnd")){
        dnd_exercise(ex_nr);
    }
}

/* Aktivieren der Drop-Down-Funktionalität */
function allowDrop(ev){
    ev.preventDefault();
}
function drag(ev){
    ev.dataTransfer.setData("text", ev.target.id);
}
function drop(ev, el){
    ev.preventDefault();
    var data = ev.dataTransfer.getData("text");
    el.appendChild(document.getElementById(data));
}

/* Funktionen zum Anzeigen und Verbergen des "Lösung"-Buttons und der Lösung */
function showSolution(solution_button, solution){
    solution_button.style.display = "none";
    solution.style.display = "block";
}
function hideSolution(solution_button, solution){
    solution_button.style.display = "block";
    solution.style.display = "none";
}

/* MULTIPLE CHOICE-/ALTERNATIVE TEXTBEISPIELE-ÜBUNG */
function mc_exercise(ex_nr){
    var solution_button = document.getElementById("solution_button_"+ex_nr);
    var reset_button = document.getElementById("reset_button_"+ex_nr);
    var solution = document.getElementById("solution_"+ex_nr);
    var feedback = document.getElementById("feedback_"+ex_nr);
    var answer = document.getElementById("answer_"+ex_nr);
    
    var answer_pool = document.getElementById("answer_pool_"+ex_nr);
    var option_pool = document.getElementById("option_pool_"+ex_nr);
    var radio_buttons = option_pool.querySelectorAll("input[type=radio]");
    var num_radio_buttons = radio_buttons.length;
    
    solution_button.addEventListener('click', function validate(){
        var checked_option = option_pool.querySelector('input[type = "radio"]:checked');
        if (checked_option != null){
            showFeedbackAndColor(checked_option);
            checkAnswer(checked_option, answer_pool);
        }else{
            feedback.innerHTML = "Bitte wählen Sie zuerst eine Antwort aus!";
            option_pool.classList.add("wrong");
        }
        lockRadioButtons();
        showSolution(solution_button, solution);
    });
    
    function showFeedbackAndColor(checked_option){
        if (checked_option.value === 'true'){
            feedback.innerHTML = "Die gewählte Antwort ist richtig!";
            feedback.classList.add("right");
            checked_option.parentElement.classList.add("right");
        }else{
            feedback.innerHTML = "Die gewählte Antwort ist falsch!";
            feedback.classList.add("wrong");
            checked_option.parentElement.classList.add("wrong");
        }
    }
    
    function checkAnswer(checked_option, answer_pool){
        for (var j = 0; j < answer_pool.children.length; j++){
            if (answer_pool.children[j].className === checked_option.id){
                answer.innerHTML = answer_pool.children[j].innerHTML;
            }
        }
    }
    
    function lockRadioButtons(){
        for (var k = 0; k < num_radio_buttons; k++){
            radio_buttons[k].disabled = true;
        }
    }
    
    reset_button.addEventListener('click', function reset(){
        clearRadioButtons();
        hideSolution(solution_button, solution);
        option_pool.classList.remove("wrong");
        feedback.innerHTML = "";
        feedback.classList.remove("right");
        feedback.classList.remove("wrong");
        answer.innerHTML = "";
    });
    
    function clearRadioButtons(){
        var checked_option = option_pool.querySelector('input[type = "radio"]:checked');
        if (checked_option != null){
            checked_option.checked = false;
        };
        var mc_options = option_pool.getElementsByClassName('option');
        for (var l = 0; l < mc_options.length; l++){
            mc_options[l].classList.remove("right", "wrong");
        }
        for (var m = 0; m < num_radio_buttons; m++){
            radio_buttons[m].disabled = false;
        }
    }
}

/* TEXTEINGABE-ÜBUNG */
function text_exercise(ex_nr){
    var solution_button = document.getElementById("solution_button_"+ex_nr);
    var reset_button = document.getElementById("reset_button_"+ex_nr);
    var solution = document.getElementById("solution_"+ex_nr);
    
    var input_field = document.getElementById("input_field_"+ex_nr);
    
    solution_button.addEventListener('click', function validate(){
        showSolution(solution_button, solution);
    });
    
    reset_button.addEventListener('click', function reset(){
        hideSolution(solution_button, solution);
        input_field.value = "";
    });
}

/* MARKIEREN-ÜBUNG */
function marker_exercise(ex_nr){
    var solution_button = document.getElementById("solution_button_"+ex_nr);
    var reset_button = document.getElementById("reset_button_"+ex_nr);
    var solution = document.getElementById("solution_"+ex_nr);
    
    var mark_button = document.getElementById("mark_button_"+ex_nr);
    var markable_text = document.getElementById("markable_text_"+ex_nr);
    const original_text = document.getElementById("markable_text_"+ex_nr).innerHTML;
            
    mark_button.addEventListener('click', function mark(){
        var range_node = document.getSelection().focusNode;
        var range = document.getSelection().getRangeAt(0);
        if (markable_text.contains(range_node)){
            var span = document.createElement('span');
            span.className = 'marked';
            span.appendChild(range.extractContents());
            range.insertNode(span);
            document.getSelection().empty();
        }
    });
    
    solution_button.addEventListener('click', function validate(){
        checkUserMarkings();
        showCorrectMarkings();
        mark_button.style.display = "none";
        showSolution(solution_button, solution);
    });
    
    function checkUserMarkings(){
        var user_markings = markable_text.querySelectorAll(".marked");
        for (var n = 0; n < user_markings.length; n++){
            if (user_markings[n].parentElement.classList.contains('correct_marker')){
                user_markings[n].className = "marked_correct";
            }else{
                user_markings[n].className = "marked_false";
            }
        }
    }
    
    function showCorrectMarkings(){
        var correct_markings = markable_text.querySelectorAll(".correct_marker");
        for (var o = 0; o < correct_markings.length; o++){
            if (correct_markings[o].parentElement.classList.contains('marked_false')){
                correct_markings[o].className = "marked_correct";
            }else{
                correct_markings[o].className = "unmarked_correct";
            }
        }
    }
    
    reset_button.addEventListener('click', function reset(){
        markable_text.innerHTML = original_text;
        mark_button.style.display = "block";
        hideSolution(solution_button, solution);
    });
}

/* LÜCKENTEXT-ÜBUNG */
function luecken_exercise(ex_nr){
    var solution_button = document.getElementById("solution_button_"+ex_nr);
    var reset_button = document.getElementById("reset_button_"+ex_nr);
    var solution = document.getElementById("solution_"+ex_nr);
    var feedback = document.getElementById("feedback_"+ex_nr);
    
    var gap_text = document.getElementById("gap_text_"+ex_nr);
    const num_gaps_total = gap_text.childElementCount;
    var num_gaps_correct = 0;
    
    solution_button.addEventListener('click', function validate(){
        for (var p = 0; p < num_gaps_total; p++){
            var gap = gap_text.getElementsByClassName("gap")[p];
            if (gap.options[gap.selectedIndex].value === "true"){
                num_gaps_correct++;
                gap.classList.add("right");
            }else{
                gap.classList.add("wrong");
            }
        }
        lockGaps();
        feedback.innerHTML = num_gaps_correct + " von " + num_gaps_total + " Lücken korrekt gefüllt. Erläuterung:";
        showSolution(solution_button, solution);
    });
    
    function lockGaps(){
        for (var q = 0; q < num_gaps_total; q++){
            gap_text.getElementsByClassName("gap")[q].disabled = true;
        }
    }
    
    reset_button.addEventListener('click', function reset(){
        clearGaps();
        feedback.innerHTML = "";
        hideSolution(solution_button, solution);
    });
    
    function clearGaps(){
        for (var r = 0; r < num_gaps_total; r++){
            var gap = gap_text.getElementsByClassName("gap")[r]
            gap.classList.remove("right", "wrong");
            gap.value = "standard";
            gap.disabled = false;
        }
    }
}

/* DRAG AND DROP-ÜBUNG */
function dnd_exercise(ex_nr){
    var solution_button = document.getElementById("solution_button_"+ex_nr);
    var reset_button = document.getElementById("reset_button_"+ex_nr);
    var solution = document.getElementById("solution_"+ex_nr);
    var feedback = document.getElementById("feedback_"+ex_nr);
    
    var drop_areas = document.getElementById("drop_areas_"+ex_nr);
    var dnd_items = document.getElementById("dnd_items_"+ex_nr);
    const dnd_items_complete = dnd_items.innerHTML;
    const num_items_total = dnd_items.childElementCount;
    var num_items_correct = 0;
    
    solution_button.addEventListener('click', function validate(){
        for (var s = 1; s <= drop_areas.children.length; s++){
            var drop_area = document.getElementById("drop_area_"+ex_nr+"_"+s);
            colorizeCheck(drop_area);
        }
        feedback.innerHTML = num_items_correct + " von " + num_items_total + " Begriffen korrekt zugeordnet.";
        
        showSolution(solution_button, solution);
    });
    
    function colorizeCheck(drop_area){
        for (var t = 0; t < drop_area.children.length; t++){
            if (drop_area.children[t].className === drop_area.id){
                drop_area.children[t].classList.add("correct");
                num_items_correct++;
            }else{
                drop_area.children[t].classList.add("wrong");
            }
            drop_area.children[t].removeAttribute("draggable");
        }
        for (var u = 0; u < dnd_items.children.length; u++){
            dnd_items.children[u].classList.add("wrong");
            dnd_items.children[u].removeAttribute("draggable");
        }
    }
    
    reset_button.addEventListener('click', function reset(){
        for (var v = 0; v < drop_areas.children.length; v++){
            drop_areas.children[v].getElementsByClassName("drop_area")[0].innerHTML = "";
        }
        dnd_items.innerHTML = dnd_items_complete;
        num_items_correct = 0;
        feedback.innerHTML = "";
        hideSolution(solution_button, solution);
    });
}