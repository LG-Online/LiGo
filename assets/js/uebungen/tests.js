/* VORBEREITUNGEN */

var start_button = document.getElementById("start_button");
var timeout_button = document.getElementById("timeout_button");
var solution_button = document.getElementById("solution_button");
var return_button = document.getElementById("return_button");
var resume_button = document.getElementById("resume_button");
var reset_button = document.getElementById("reset_button");

var correct_answers = 0;
var exercises = document.querySelectorAll('.exercise');
var general_feedback = document.getElementById("feedback");

var progress_bar = document.getElementById('progress-bar');
var stopTimer = false;
var time = progress_bar.getAttribute("aria-valuemax");
const time_text = document.getElementById('time_text').innerHTML;

start_button.addEventListener('click', function start(){
    start_button.style.display = "none";
    document.getElementById('exercises').style.display = "block";
    startTimer(time);
});

function startTimer(time) {
    stopTimer = false;
    var end = Date.now() + (time*1000);
    var frame = function(){
        var time_left = Math.max(0, end - Date.now());
        progress_bar.style.width = (time_left*100)/(time*1000)+'%';
        if ((progress_bar.style.width < '66%') && (progress_bar.style.width > '2%')){
            progress_bar.classList.remove("max_time");
            progress_bar.classList.add("mid_time");
        }
        if ((progress_bar.style.width < '33%') && (progress_bar.style.width > '2%')){
            progress_bar.classList.remove("mid_time");
            progress_bar.classList.add("min_time");
        }
        if (progress_bar.style.width === '0%'){
            disableScroll();
            document.getElementById("timeout_pop_up").style.display = "flex";
        }
        time_seconds = (time_left/1000).toFixed(0);
        var minutes = Math.floor(time_seconds/60);
        var rest_seconds = time_seconds%60;
        progress_bar.innerHTML = minutes+" Min. "+rest_seconds+" Sek. verbleibend";
        if (stopTimer){
            return;
        }
        else if (time_left === 0){
            return;
        }
        requestAnimationFrame(frame);
    };
    requestAnimationFrame(frame);
}

timeout_button.addEventListener('click', function(){
    document.getElementById("timeout_pop_up").style.display = "none";
    enableScroll();
    secondCheck(exercises);
});

solution_button.addEventListener('click', function validate(){
    firstCheck(exercises);
    if (firstCheck(exercises) === "Check passed"){
        secondCheck(exercises);
    }
});

function firstCheck(exercises){
    var not_checked = [];
    for (var i = 0; i < exercises.length; i++){
        var id = exercises[i].getElementsByClassName('solution')[0].getAttribute('id');
        var ex_nr = id.substring(id.indexOf("_") + 1);
        var option_pool = document.getElementById("option_pool_"+ex_nr);
        var checked_option = option_pool.querySelector('input[type = "radio"]:checked');
        
        if (checked_option === null){
            var question_number = i+1;
            not_checked.push("Frage "+question_number);
        }
    }
    
    if (not_checked.length === 0) {
        return "Check passed";
    }else{
        disableScroll();
        document.getElementById("warning_text").innerHTML = "Sie haben noch nicht bei jeder Frage eine Antwort ausgewählt. Es fehlen noch Antworten auf: "+ not_checked.join(", ")+"."
        document.getElementById("warning_pop_up").style.display = "flex";
        return;
    }
}

return_button.addEventListener('click', function(){
    document.getElementById("warning_pop_up").style.display = "none";
    enableScroll();
});

resume_button.addEventListener('click', function(){
    document.getElementById("warning_pop_up").style.display = "none";
    enableScroll();
    secondCheck(exercises);
});

function secondCheck(exercises){
    stopTimer = true;
     for (var i = 0; i < exercises.length; i++){
        var id = exercises[i].getElementsByClassName('solution')[0].getAttribute('id');
        var ex_nr = id.substring(id.indexOf("_") + 1);
        checkExercises(ex_nr);
     }
    general_feedback.innerHTML = correct_answers+" von "+exercises.length+" Fragen richtig beantwortet.";
    showSolution();
}

function checkExercises(ex_nr){
    var solution = document.getElementById("solution_"+ex_nr);
    var feedback = document.getElementById("feedback_"+ex_nr);
    var answer = document.getElementById("answer_"+ex_nr);
    
    var answer_pool = document.getElementById("answer_pool_"+ex_nr);
    var option_pool = document.getElementById("option_pool_"+ex_nr);
    var radio_buttons = option_pool.querySelectorAll("input[type=radio]");
    var checked_option = option_pool.querySelector('input[type = "radio"]:checked');
    
    checkAnswer(checked_option, answer_pool);
    showFeedbackAndColor(checked_option);
    lockRBs(radio_buttons);
    
    function checkAnswer(checked_option, answer_pool){
        if (checked_option === null){
            return
        }else{
            for (var j = 0; j < answer_pool.children.length; j++){
                if (answer_pool.children[j].className === checked_option.id){
                    answer.innerHTML = answer_pool.children[j].innerHTML;
                }
            }
        }
    }
    
    function showFeedbackAndColor(checked_option){
        if (checked_option === null){
            feedback.innerHTML = "Keine Antwort ausgewählt!";
            feedback.classList.add("wrong");
            option_pool.classList.add("wrong");
        }else if (checked_option.value === 'true'){
            feedback.innerHTML = "Die gewählte Antwort ist richtig!";
            feedback.classList.add("right");
            checked_option.parentElement.classList.add("right");
            correct_answers += 1;
        }else if (checked_option.value === 'false'){
            feedback.innerHTML = "Die gewählte Antwort ist falsch!";
            feedback.classList.add("wrong");
            checked_option.parentElement.classList.add("wrong");
        }
        solution.style.display = "block";
    }
    
    function lockRBs(radio_buttons){
        for (var k = 0; k < radio_buttons.length; k++){
            radio_buttons[k].disabled = true;
        }
    }
    
}

reset_button.addEventListener('click', function reset(){
    stopTimer = true;
    for (var i = 0; i < exercises.length; i++){
        var id = exercises[i].getElementsByClassName('solution')[0].getAttribute('id');
        var ex_nr = id.substring(id.indexOf("_") + 1);
        
        var solution = document.getElementById("solution_"+ex_nr);
        var feedback = document.getElementById("feedback_"+ex_nr);
        var answer = document.getElementById("answer_"+ex_nr);
        
        var answer_pool = document.getElementById("answer_pool_"+ex_nr);
        var option_pool = document.getElementById("option_pool_"+ex_nr);
        var radio_buttons = option_pool.querySelectorAll("input[type=radio]");
        var checked_option = option_pool.querySelector('input[type = "radio"]:checked');
        
        clearOptions(checked_option, option_pool);
        unlockRBs(radio_buttons);
        option_pool.classList.remove("wrong");
        feedback.innerHTML = "";
        feedback.classList.remove("right");
        feedback.classList.remove("wrong");
        answer.innerHTML = "";
    }
    hideSolution();
    clearProgressBar(progress_bar);
    correct_answers = 0;
});


function clearOptions(checked_option, option_pool){
    if (checked_option != null){
        checked_option.checked = false;
    };
    var mc_options = option_pool.getElementsByClassName('option');
    for (var l = 0; l < mc_options.length; l++){
        mc_options[l].classList.remove("right", "wrong");
    };
}

function unlockRBs(radio_buttons){
    for (var k = 0; k < radio_buttons.length; k++){
        radio_buttons[k].disabled = false;
    }
}

/* Zurücksetzen des Fortschrittsbalkens */
function clearProgressBar(progress_bar){
    progress_bar.innerHTML = time_text;
    progress_bar.style.width = "100%";
    progress_bar.classList.remove("min_time", "mid_time");
    progress_bar.classList.add("max_time");
}

/* Funktionen zum Anzeigen und Verbergen des "Lösung"-Buttons und der Lösung */
function showSolution(){
    reset_button.style.display = "block";
    solution_button.style.display = "none";
    general_feedback.style.display = "block";
    general_feedback.scrollIntoView();
}
function hideSolution(){
    general_feedback.style.display = "none";
    reset_button.style.display = "none";
    document.getElementById('exercises').style.display = "none";
    start_button.style.display = "block";
    solution_button.style.display = "block";
    document.getElementById("top").scrollIntoView();
}


/* Funtionen zum Deaktiveren und Aktivieren der Scroll-Funktion */
var keys = {37: 1, 38: 1, 39: 1, 40: 1};

function preventDefault(e) {
  e.preventDefault();
}

function preventDefaultForScrollKeys(e) {
  if (keys[e.keyCode]) {
    preventDefault(e);
    return false;
  }
}

var supportsPassive = false;
try {
    window.addEventListener("test", null, Object.defineProperty({}, 'passive', {
        get: function () { supportsPassive = true; } 
    }));
} catch(e) {}

var wheelOpt = supportsPassive ? { passive: false } : false;
var wheelEvent = 'onwheel' in document.createElement('div') ? 'wheel' : 'mousewheel';

function disableScroll() {
    window.addEventListener('DOMMouseScroll', preventDefault, false);
    window.addEventListener(wheelEvent, preventDefault, wheelOpt);
    window.addEventListener('touchmove', preventDefault, wheelOpt);
    window.addEventListener('keydown', preventDefaultForScrollKeys, false);
}

function enableScroll() {
    window.removeEventListener('DOMMouseScroll', preventDefault, false);
    window.removeEventListener(wheelEvent, preventDefault, wheelOpt); 
    window.removeEventListener('touchmove', preventDefault, wheelOpt);
    window.removeEventListener('keydown', preventDefaultForScrollKeys, false);
}