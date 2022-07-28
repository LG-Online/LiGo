// VORBEREITUNGEN

// Deklarieren der Button-Variablen für einen einfacheren Button-Zugriff im weiteren Verlauf
var start_button = document.getElementById("start_button");
var timeout_button = document.getElementById("timeout_button");
var solution_button = document.getElementById("solution_button");
var return_button = document.getElementById("return_button");
var resume_button = document.getElementById("resume_button");
var reset_button = document.getElementById("reset_button");

// Deklarieren der benötigten globalen Variablen für das Auswerten der Testergebnisse
var correct_answers = 0;
var exercises = document.querySelectorAll('.exercise');
var general_feedback = document.getElementById("feedback");

// Deklarieren der benötigten globalen Variablen für die Kontrolle des Timers/Fortschrittsbalkens
var progress_bar = document.getElementById('progress-bar');
var stopTimer = false;
var time = progress_bar.getAttribute("aria-valuemax");
const time_text = document.getElementById('time_text').innerHTML;


// TEST STARTEN

// Bei Klick auf den "Test starten"-Button: Verbergen des Buttons; Anzeigen der Übungen/Fragen; Starten des Timers
start_button.addEventListener('click', function start(){
    start_button.style.display = "none";
    document.getElementById('exercises').style.display = "block";
    startTimer(time);
});


// TIMER/FORTSCHRITTSBALKEN

function startTimer(time) {
    // Zurücksetzen der Variable zum Anhalten des Timers
    stopTimer = false;
    var end = Date.now() + (time*1000);
    var frame = function(){
        // Berechnen der noch verbleibenden Zeit
        var time_left = Math.max(0, end - Date.now());
        // Breite des Fortschrittsbalkens auf Basis der noch verbleibenden Zeit darstellen (bzw. schrumpfen lassen)
        progress_bar.style.width = (time_left*100)/(time*1000)+'%';
        // Nachdem 1/3 der Zeit verstrichen ist bzw. nur noch 2/3 der Zeit übrig sind: Ändern der Klasse für einen Wechsel von grüner zu blauer Balkenfarbe (-> Siehe tests.scss-Datei im_sass-Ordner)
        // (> 2% ist notwendig, damit es nicht zu einem Fehler kommt, bei dem der Fortschrittsbalken nach einem Neustart des Tests sofort rot wird)
        if ((progress_bar.style.width < '66%') && (progress_bar.style.width > '2%')){
            progress_bar.classList.remove("max_time");
            progress_bar.classList.add("mid_time");
        }
        // Nachdem 2/3 der Zeit verstrichen sind bzw. nur noch 1/3 der Zeit übrig ist: Ändern der Klasse für einen Wechsel von blauer zu roter Balkenfarbe (-> Siehe tests.scss-Datei)
        if ((progress_bar.style.width < '33%') && (progress_bar.style.width > '2%')){
            progress_bar.classList.remove("mid_time");
            progress_bar.classList.add("min_time");
        }
        // Sobald die Zeit abgelaufen ist bzw. der Balken eine Länge von 0 erreicht hat: Deaktivieren der Scroll-Funktion und Anzeigen des Timeout-Pop-Ups
        // Der Nutzer hat dann nur noch die Möglichkeit, auf einen Button zu klicken, um den Test auswerten und sich die Lösungen/Ergebnisse anzeigen zu lassen
        if (progress_bar.style.width === '0%'){
            disableScroll();
            document.getElementById("timeout_pop_up").style.display = "flex";
        }
        // Umrechnen der verbleibenden Zeit von Sekunden in Minuten + Sekunden
        time_seconds = (time_left/1000).toFixed(0);
        var minutes = Math.floor(time_seconds/60);
        var rest_seconds = time_seconds%60;
        // Anzeigen der verbleibenden Zeit innerhalb des Fortschrittsbalkens
        progress_bar.innerHTML = minutes+" Min. "+rest_seconds+" Sek. verbleibend";
        // Sobald die stopTimer-Variable auf "true" gesetzt wurde (-> Beim Zurücksetzen des Tests oder Auswerten der Ergebnisse) oder die Zeit abgelaufen ist: Anhalten des Countdowns/Balkenfortschritts
        if (stopTimer){
            return;
        }
        else if (time_left === 0){
            return;
        }
        // Nutzen von "requestAnimationFrame" für eine flüssige Darstellung der Fortschrittsbalken-Animation im Browser
        requestAnimationFrame(frame);
    };
    requestAnimationFrame(frame);
}

// Bei Klick auf den "Ergebnisse auswerten"-Button im Timeout-Pop-Up: Schließen des Pop-Ups; Reaktivieren der Scroll-Funktion; Auswerten der Testergebnisse (-> Der Nutzer kann die Übungen nicht mehr weiter bearbeiten)
timeout_button.addEventListener('click', function(){
    document.getElementById("timeout_pop_up").style.display = "none";
    enableScroll();
    secondCheck(exercises);
});


// ERGEBNISSE AUSWERTEN

// Bei Klick auf den "Ergebnisse auswerten"-Button: Durchführen des 1. Checks -> Falls der 1. Check erfolgreich abgeschlossen wurde: Durchführen des 2. Checks
solution_button.addEventListener('click', function validate(){
    firstCheck(exercises);
    if (firstCheck(exercises) === "Check passed"){
        secondCheck(exercises);
    }
});

// 1. Check, bei dem getestet wird, ob der Nutzer bei jeder Frage eine Antwort ausgewählt hat
function firstCheck(exercises){
    var not_checked = [];
    // Iterieren über sämtliche Fragen -> Überprüfen, ob der Nutzer eine Antwort für die aktuelle Frage ausgewählt hat -> Falls nein: Hinzufügen der nicht beantworteten Frage zu einem Array
    // Dieses Array wird im Folgenden genutzt, um dem Nutzer im Warnung-Pop-Up ein genaues Feedback dazu zu geben, welche Fragen er noch nicht beantwortet hat
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
    // Falls es keine unbeantworteten Fragen gibt: "Check passed" zurückgeben, wodurch der 2. Check (zur eigentlichen Auswertung der Testergebnisse) eingeleitet wird
    if (not_checked.length === 0) {
        return "Check passed";
    // Falls es unbeantwortete Fragen gibt: Deaktivieren der Scroll-Funktion; Befüllen des Warnung-Pop-Ups mit dem Hinweis auf die noch unbeantworteten Fragen; Anzeigen des Warnung-Pop-Ups
    }else{
        disableScroll();
        document.getElementById("warning_text").innerHTML = "Sie haben noch nicht bei jeder Frage eine Antwort ausgewählt. Es fehlen noch Antworten auf: "+ not_checked.join(", ")+"."
        document.getElementById("warning_pop_up").style.display = "flex";
        return;
    }
}

// Bei Klick auf den "Weiter bearbeiten"-Button im Warnung-Pop-Up: Schließen des Pop-Ups; Reaktivieren der Scroll-Funktion (-> Der Nutzer kann die Übungen weiter bearbeiten)
return_button.addEventListener('click', function(){
    document.getElementById("warning_pop_up").style.display = "none";
    enableScroll();
});

// Bei Klick auf den "Trotzdem auswerten"-Button im Warnung-Pop-Up: Schließen des Pop-Ups; Reaktivieren der Scroll-Funktion; Auswerten der Testergebnisse (-> Der Nutzer kann die Übungen nicht mehr weiter bearbeiten)
resume_button.addEventListener('click', function(){
    document.getElementById("warning_pop_up").style.display = "none";
    enableScroll();
    secondCheck(exercises);
});

// 2. Check, bei dem die eigentliche Auswertung der Tests stattfindet
function secondCheck(exercises){
    // Anhalten des Countdowns und des Fortschrittsbalkens
    stopTimer = true;
    // Iterieren über alle Übungen/Fragen -> Überprüfen, ob die Frage korrekt beantwortet wurde
    for (var i = 0; i < exercises.length; i++){
        var id = exercises[i].getElementsByClassName('solution')[0].getAttribute('id');
        var ex_nr = id.substring(id.indexOf("_") + 1);
            checkExercises(ex_nr);
    }
    // Feedback über richtig beantwortete Fragen und Lösungen zu den Fragen anzeigen
    general_feedback.innerHTML = correct_answers+" von "+exercises.length+" Fragen richtig beantwortet.";
    showSolution();
}

function checkExercises(ex_nr){
    // Deklarieren der benötigten Variablen für das Überprüfen der Fragen/Antworten
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
        // Falls keine Anwort für die Frage ausgewählt wurde: Abbrechen
        if (checked_option === null){
            return
        // Ansonsten: Iterieren über den Antwort-Pool -> Heraussuchen der passenden Antwort (bzw. Erklärung) zur vom Nutzer ausgewählten Option (mittels Abgleich von Klasse der Antwort und ID der ausgewählten Option)
        }else{
            for (var j = 0; j < answer_pool.children.length; j++){
                if (answer_pool.children[j].className === checked_option.id){
                    answer.innerHTML = answer_pool.children[j].innerHTML;
                }
            }
        }
    }
    
    // Generieren und Anzeigen des Feedbacks; Einfärben des Feedbacks und der Übung über die "wrong" und "right"-Klassen (-> Siehe uebungen.scss-Datei im _sass-Ordner)
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
        // Anzeigen der Lösung
        solution.style.display = "block";
    }
    
    // Sperren (= nicht-anklickbar-machen) der Radio Buttons
    function lockRBs(radio_buttons){
        for (var k = 0; k < radio_buttons.length; k++){
            radio_buttons[k].disabled = true;
        }
    }
    
}


// TEST ZURÜCKSETZEN

// Bei Klick auf den "Test zurücksetzen"-Button:
reset_button.addEventListener('click', function reset(){
    // Anhalten des Countdowns und des Fortschrittsbalkens
    stopTimer = true;
    // Iterieren über alle Übungen/Fragen
    for (var i = 0; i < exercises.length; i++){
        // Deklarieren der benötigten Variablen zum Bereinigen/Zurücksetzen der Übungen/Fragen
        var id = exercises[i].getElementsByClassName('solution')[0].getAttribute('id');
        var ex_nr = id.substring(id.indexOf("_") + 1);
        var solution = document.getElementById("solution_"+ex_nr);
        var feedback = document.getElementById("feedback_"+ex_nr);
        var answer = document.getElementById("answer_"+ex_nr);
        var answer_pool = document.getElementById("answer_pool_"+ex_nr);
        var option_pool = document.getElementById("option_pool_"+ex_nr);
        var radio_buttons = option_pool.querySelectorAll("input[type=radio]");
        var checked_option = option_pool.querySelector('input[type = "radio"]:checked');
        // Ausführen der Funktionen und Befehle zum Bereinigen/Zurücksetzen der Übungen/Fragen
        clearOptions(checked_option, option_pool);
        unlockRBs(radio_buttons);
        option_pool.classList.remove("wrong");
        feedback.innerHTML = "";
        feedback.classList.remove("right");
        feedback.classList.remove("wrong");
        answer.innerHTML = "";
    }
    // Ausführen der Funktionen und Befehle zum Bereinigen/Zurücksetzen der übrigen Test-Elemente/Variablen
    hideSolution();
    clearProgressBar(progress_bar);
    correct_answers = 0;
});

// Zurücksetzen der MC-Optionen
function clearOptions(checked_option, option_pool){
    // Entfernen der Nutzer-Auswahl bei den Radio Buttons
    if (checked_option != null){
        checked_option.checked = false;
    }
    // Entfernen der Attribute für die grüne/rote Einfärbung der richtigen/falschen Antworten
    var mc_options = option_pool.getElementsByClassName('option');
    for (var l = 0; l < mc_options.length; l++){
        mc_options[l].classList.remove("right", "wrong");
    }
}

// Entsperren (= wieder-anklickbar-machen) der Radio Buttons
function unlockRBs(radio_buttons){
    for (var k = 0; k < radio_buttons.length; k++){
        radio_buttons[k].disabled = false;
    }
}

// Zurücksetzen des Fortschrittsbalkens -> Zeitangabe (zurück auf Ausgangszeit); Länge (zurück auf volle Länge); Farbe (zurück auf grün)
function clearProgressBar(progress_bar){
    progress_bar.innerHTML = time_text;
    progress_bar.style.width = "100%";
    progress_bar.classList.remove("min_time", "mid_time");
    progress_bar.classList.add("max_time");
}


// WEITERE FUNKTIONEN

// Funktionen zum Anzeigen oder Verbergen des "Lösung anzeigen"-Buttons und der Lösung
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


// Funtionen zum Deaktiveren oder Reaktivieren der Scroll-Funktion
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