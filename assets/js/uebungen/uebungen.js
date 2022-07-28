// VORBEREITUNGEN

// Iterieren über alle Übungen auf der Seite
var exercises = document.querySelectorAll('.exercise');
for (var i = 0; i < exercises.length; i++){
    var current_exercise = exercises[i];
    check_exercise(current_exercise);
}

// Durchnummerieren und Überprüfen des Übungstyps der jeweiligen Übung
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


// MULTIPLE CHOICE-/ALTERNATIVE TEXTBEISPIELE-ÜBUNG

function mc_exercise(ex_nr){
    // Deklarieren der Variablen für den einfacheren Zugriff auf Elemente, die essenziell für die nachfolgenden Funktionen sind
    var solution_button = document.getElementById("solution_button_"+ex_nr);
    var reset_button = document.getElementById("reset_button_"+ex_nr);
    var solution = document.getElementById("solution_"+ex_nr);
    var feedback = document.getElementById("feedback_"+ex_nr);
    var answer = document.getElementById("answer_"+ex_nr);
    var answer_pool = document.getElementById("answer_pool_"+ex_nr);
    var option_pool = document.getElementById("option_pool_"+ex_nr);
    var radio_buttons = option_pool.querySelectorAll("input[type=radio]");
    
    // Bei Klick auf den "Lösung anzeigen"-Button: Validieren der MC-Optionsauswahl
    solution_button.addEventListener('click', function validate(){
        var checked_option = option_pool.querySelector('input[type = "radio"]:checked');
        // Testen, ob eine Antwort-Option ausgewählt wurde -> Falls ja:
        if (checked_option != null){
            // Weiteres Überprüfen der ausgewählten Option
            showFeedbackAndColor(checked_option);
            checkAnswer(checked_option, answer_pool);
        // Ansonsten, also falls keine Antwort-Option ausgewählt wurde:
        }else{
            // Generieren des Feedbacks; rotes Einfärben des Feedbacks und der Optionen über die Klasse "wrong" (-> Siehe uebungen.scss-Datei im _sass-Ordner)
            feedback.innerHTML = "Bitte wählen Sie zuerst eine Antwort aus!";
            feedback.classList.add("wrong");
            option_pool.classList.add("wrong");
        }
        // In beiden Fällen: Buttons sperren; Lösung bzw. Feedback anzeigen
        lockRBs(radio_buttons);
        showSolution(solution_button, solution);
    });
    
    function showFeedbackAndColor(checked_option){
        // Testen, ob die ausgewählte Option den Wert "true" besitzt (und somit richtig ist) -> Falls ja:
        if (checked_option.value === 'true'){
            // Generieren des entsprechenden Feedbacks; grünes Einfärben des Feedbacks und der Optionen über die Klasse "right" (-> Siehe uebungen.scss-Datei)
            feedback.innerHTML = "Die gewählte Antwort ist richtig!";
            feedback.classList.add("right");
            checked_option.parentElement.classList.add("right");
        // Ansonsten, also falls die ausgewählte Option nicht den Wert "true" besitzt (und somit falsch ist):
        }else{
            // Generieren des entsprechenden Feedbacks; rotes Einfärben des Feedbacks und der Optionen über die Klasse "wrong" (-> Siehe uebungen.scss-Datei)
            feedback.innerHTML = "Die gewählte Antwort ist falsch!";
            feedback.classList.add("wrong");
            checked_option.parentElement.classList.add("wrong");
        }
    }
    
    function checkAnswer(checked_option, answer_pool){
        // Iterieren über den Antwort-Pool -> Heraussuchen der passenden Antwort (bzw. Erklärung) zur vom Nutzer ausgewählten Option (mittels Abgleich von Klasse der Antwort und ID der ausgewählten Option)
        for (var j = 0; j < answer_pool.children.length; j++){
            if (answer_pool.children[j].className === checked_option.id){
                answer.innerHTML = answer_pool.children[j].innerHTML;
            }
        }
    }
    
    // Sperren (= nicht-anklickbar-machen) der Radio Buttons
    function lockRBs(radio_buttons){
        for (var k = 0; k < radio_buttons.length; k++){
            radio_buttons[k].disabled = true;
        }
    }
    
    // Bei Klick auf den "Übung zurücksetzen"-Button:
    reset_button.addEventListener('click', function reset(){
        // Ausführen der Funktionen und Befehle zum Bereinigen/Zurücksetzen der Übung
        clearOptions();
        unlockRBs(radio_buttons);
        hideSolution(solution_button, solution);
        option_pool.classList.remove("wrong");
        feedback.innerHTML = "";
        feedback.classList.remove("right");
        feedback.classList.remove("wrong");
        answer.innerHTML = "";
    });
    
    function clearOptions(){
        var checked_option = option_pool.querySelector('input[type = "radio"]:checked');
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
        for (var m = 0; m < radio_buttons.length; m++){
            radio_buttons[m].disabled = false;
        }
    }
}


// TEXTEINGABE-ÜBUNG

function text_exercise(ex_nr){
    // Deklarieren der Variablen für den einfacheren Zugriff auf Elemente, die essenziell für die nachfolgenden Funktionen sind
    var solution_button = document.getElementById("solution_button_"+ex_nr);
    var reset_button = document.getElementById("reset_button_"+ex_nr);
    var solution = document.getElementById("solution_"+ex_nr);
    var input_field = document.getElementById("input_field_"+ex_nr);
    
    // Bei Klick auf den "Lösung anzeigen"-Button: Anzeigen der Lösung
    solution_button.addEventListener('click', function validate(){
        showSolution(solution_button, solution);
    });
    
    // Bei Klick auf den "Übung zurücksetzen"-Button: Verbergen der Lösung; Leeren des Eingabefelds
    reset_button.addEventListener('click', function reset(){
        hideSolution(solution_button, solution);
        input_field.value = "";
    });
}


// MARKIEREN-ÜBUNG

function marker_exercise(ex_nr){
    // Deklarieren der Variablen für den einfacheren Zugriff auf Elemente, die essenziell für die nachfolgenden Funktionen sind
    var solution_button = document.getElementById("solution_button_"+ex_nr);
    var reset_button = document.getElementById("reset_button_"+ex_nr);
    var solution = document.getElementById("solution_"+ex_nr);
    var mark_button = document.getElementById("mark_button_"+ex_nr);
    var markable_text = document.getElementById("markable_text_"+ex_nr);
    const original_text = document.getElementById("markable_text_"+ex_nr).innerHTML;
    
    // Bei Klick auf den "Markierung setzen"-Button: Validieren und Markieren des ausgewählten Textabschnitts
    mark_button.addEventListener('click', function mark(){
        var range_node = document.getSelection().focusNode;
        var range = document.getSelection().getRangeAt(0);
        // Testen, ob der markierte Textabschnitt Teil des markierbaren Texts ist (-> Dadurch: Verhindern, dass der Nutzer eine Markierung außerhalb des dafür vorgesehenen Texts setzt) -> Falls ja:
        if (markable_text.contains(range_node)){
            // Generieren eines <span class="marked">-Elements und Umschließen des vom Nutzer ausgewählten Texts mit diesem Element
            var span = document.createElement('span');
            span.className = 'marked';
            span.appendChild(range.extractContents());
            range.insertNode(span);
            // Zurücksetzen/Leeren der gespeicherten Textauswahl, nachdem die Markierung gesetzt wurde (-> Der Nutzer kann nun eine weitere Stelle zur Markierung auswählen)
            document.getSelection().empty();
        }
    });
    
    // Bei Klick auf den "Lösung anzeigen"-Button: Validieren des vom Nutzer markierten Texts; Verbergen des Markieren-Buttons; Anzeigen der korrekten Markierungen und der Lösung
    solution_button.addEventListener('click', function validate(){
        checkUserMarkings();
        showCorrectMarkings();
        mark_button.style.display = "none";
        showSolution(solution_button, solution);
    });
    
    function checkUserMarkings(){
        // Speichern aller Nutzer-Markierungen in einer Variable -> Iterieren über diese Markierungen
        var user_markings = markable_text.querySelectorAll(".marked");
        for (var n = 0; n < user_markings.length; n++){
            // Testen, ob der vom Nutzer markierte Text ein Teil des korrekten/gesuchten Textabschnitts ist -> Falls ja: 
            // Hinzufügen der "marked_correct"-Klasse, über die der Text grün hinterlegt wird (-> Siehe uebungen.scss-Datei)
            if (user_markings[n].parentElement.classList.contains('correct_marker')){
                user_markings[n].className = "marked_correct";
            // Ansonsten, also falls ein falscher/nicht gesuchter Textabschnitt vom Nutzer markiert wurde:
            // Hinzufügen der "marked_false"-Klasse, über die der Text rot hinterlegt wird (-> Siehe uebungen.scss-Datei)
            }else{
                user_markings[n].className = "marked_false";
            }
        }
    }
    
    function showCorrectMarkings(){
        // Speichern aller korrekten/gesuchten Textabschnitte in einer Variable -> Iterieren über diese Textabschnitte
        var correct_markings = markable_text.querySelectorAll(".correct_marker");
        for (var o = 0; o < correct_markings.length; o++){
            // Testen, ob die korrekte/gesuchte Stelle ein Teil des vom Nutzer markierten Texts ist -> Falls ja: 
            // Hinzufügen der "marked_correct"-Klasse, über die der Text grün hinterlegt wird (-> Siehe uebungen.scss-Datei)
            // Dadurch wird die korrekte Stelle grün hinterlegt, die überflüssigen/falschen Nutzer-Markierungen davor und danach bleiben jedoch rot hinterlegt
            if (correct_markings[o].parentElement.classList.contains('marked_false')){
                correct_markings[o].className = "marked_correct";
            // Ansonsten, also falls eine gesuchte Stelle gar nicht vom Nutzer markiert wurde:
            // Hinzufügen der "unmarked_correct"-Klasse, über die der Text blau hinterlegt wird (-> Siehe uebungen.scss-Datei)
            }else{
                correct_markings[o].className = "unmarked_correct";
            }
        }
    }
    
    // Bei Klick auf den "Übung zurücksetzen"-Button: Zurücksetzen des markierbaren Texts; Anzeigen des Markieren-Buttons; Verbergen der Lösung
    reset_button.addEventListener('click', function reset(){
        markable_text.innerHTML = original_text;
        mark_button.style.display = "block";
        hideSolution(solution_button, solution);
    });
}


// LÜCKENTEXT-ÜBUNG

function luecken_exercise(ex_nr){
    // Deklarieren der Variablen für den einfacheren Zugriff auf Elemente, die essenziell für die nachfolgenden Funktionen sind
    var solution_button = document.getElementById("solution_button_"+ex_nr);
    var reset_button = document.getElementById("reset_button_"+ex_nr);
    var solution = document.getElementById("solution_"+ex_nr);
    var feedback = document.getElementById("feedback_"+ex_nr);
    var gap_text = document.getElementById("gap_text_"+ex_nr);
    const num_gaps_total = gap_text.childElementCount;
    var num_gaps_correct = 0;
    
    // Bei Klick auf den "Lösung anzeigen"-Button: Validieren des Lückentexts
    solution_button.addEventListener('click', function validate(){
        // Iterieren über alle Lücken
        for (var p = 0; p < num_gaps_total; p++){
            var gap = gap_text.getElementsByClassName("gap")[p];
            // Testen, ob die ausgewählte Option den Wert "true" besitzt (und somit richtig ist) -> Falls ja:
            if (gap.options[gap.selectedIndex].value === "true"){
                // Grünes Einfärben der Textlücke über die Klasse "right"; Erhöhen der Anzahl an korrekt ausgefüllten Lücken um 1
                gap.classList.add("right");
                num_gaps_correct++;
            // Ansonsten, also falls die ausgewählte Option nicht den Wert "true" besitzt (und somit falsch ist):
            }else{
                // Rotes Einfärben der Textlücke über die Klasse "wrong"
                gap.classList.add("wrong");
            }
        }
        // Sperren der Lücken; Generieren des Feedbacks basierend auf den korrekt befüllten und den insgesamt vorhandenen Lücken; Anzeigen der Lösung
        lockGaps();
        feedback.innerHTML = num_gaps_correct + " von " + num_gaps_total + " Lücken korrekt gefüllt. Erläuterung:";
        showSolution(solution_button, solution);
    });
    
    // Sperren (= nicht-anklickbar-machen) der Lücken
    function lockGaps(){
        for (var q = 0; q < num_gaps_total; q++){
            gap_text.getElementsByClassName("gap")[q].disabled = true;
        }
    }
    
    // Bei Klick auf den "Übung zurücksetzen"-Button: Zurücksetzen/Bereinigen der Lücken und des Feedbacks; Verbergen der Lösung
    reset_button.addEventListener('click', function reset(){
        clearGaps();
        feedback.innerHTML = "";
        hideSolution(solution_button, solution);
    });
    
    function clearGaps(){
        // Iterieren über alle Lücken -> Entfernen der Klassen zur farblichen Markierung, Zurücksetzen auf den Standardwert und Entsperren jeder Lücke
        for (var r = 0; r < num_gaps_total; r++){
            var gap = gap_text.getElementsByClassName("gap")[r]
            gap.classList.remove("right", "wrong");
            gap.value = "standard";
            gap.disabled = false;
        }
    }
}


// DRAG AND DROP-ÜBUNG

function dnd_exercise(ex_nr){
    // Deklarieren der Variablen für den einfacheren Zugriff auf Elemente, die essenziell für die nachfolgenden Funktionen sind
    var solution_button = document.getElementById("solution_button_"+ex_nr);
    var reset_button = document.getElementById("reset_button_"+ex_nr);
    var solution = document.getElementById("solution_"+ex_nr);
    var feedback = document.getElementById("feedback_"+ex_nr);
    var drop_areas = document.getElementById("drop_areas_"+ex_nr);
    var dnd_items = document.getElementById("dnd_items_"+ex_nr);
    const dnd_items_complete = dnd_items.innerHTML;
    const num_items_total = dnd_items.childElementCount;
    var num_items_correct = 0;
    
    // Bei Klick auf den "Lösung anzeigen"-Button:
    solution_button.addEventListener('click', function validate(){
        // Iterieren über alle Drop-Areas -> Ausführen der Funktion zur Ergebnisüberprüfung für jede Drop-Area
        for (var s = 1; s <= drop_areas.children.length; s++){
            var drop_area = document.getElementById("drop_area_"+ex_nr+"-"+s);
            colorizeCheck(drop_area);
        }
        // Generieren des Feedbacks basierend auf den korrekt zugeordneten und den insgesamt vorhandenen DND-Items; Anzeigen der Lösung
        feedback.innerHTML = num_items_correct + " von " + num_items_total + " Begriffen korrekt zugeordnet.";
        showSolution(solution_button, solution);
    });
    
    function colorizeCheck(drop_area){
        // Iterieren über alle Drop-Area-Kindelemente (= DND-Items, die der Nutzer in der jeweiligen Drop-Area platziert hat)
        for (var t = 0; t < drop_area.children.length; t++){
            // Testen, ob die Klasse des zugeordneten DND-Items mit der ID der Drop-Area übereinstimmt (und das Item somit richtig zugeordnet wurde) -> Falls ja:
            if (drop_area.children[t].className === drop_area.id){
                // Grünes Einfärben des DND-Items über die Klasse "wrong"; Erhöhen der Anzahl an korrekt zugeordneten Items um 1
                drop_area.children[t].classList.add("correct");
                num_items_correct++;
            // Ansonsten, also falls die Klasse des zugeordneten DND-Items nicht mit der ID der Drop-Area übereinstimmt (und das Item somit falsch zugeordnet wurde):
            }else{
                // Rotes Einfärben des DND-Items über die Klasse "wrong"
                drop_area.children[t].classList.add("wrong");
            }
            // In jedem Fall: Entfernen des "draggable"-Attributs bei jedem Item, um die DND-Funktion zu unterbinden
            drop_area.children[t].removeAttribute("draggable");
        }
        // Iterieren über alle DND-Items, die noch an ihrer ursprünglichen Position sind (und somit nicht vom Nutzer zu einer Drop-Area zugeordnet wurden) -> 
        for (var u = 0; u < dnd_items.children.length; u++){
            // Rotes Einfärben des DND-Items über die Klasse "wrong"; Entfernen des "draggable"-Attributs bei jedem Item, um die DND-Funktion zu unterbinden
            dnd_items.children[u].classList.add("wrong");
            dnd_items.children[u].removeAttribute("draggable");
        }
    }
    
    // Bei Klick auf den "Übung zurücksetzen"-Button:
    reset_button.addEventListener('click', function reset(){
        // Iterieren über alle Drop-Areas -> Zurücksetzen/Leeren jeder Area
        for (var v = 0; v < drop_areas.children.length; v++){
            drop_areas.children[v].getElementsByClassName("drop_area")[0].innerHTML = "";
        }
        // Zurücksetzen der DND-Items, der Anzahl der korrekt zugeordneten Items und des Feedbacks; Verstecken der Lösung
        dnd_items.innerHTML = dnd_items_complete;
        num_items_correct = 0;
        feedback.innerHTML = "";
        hideSolution(solution_button, solution);
    });
}


// WEITERE FUNKTIONEN

// Funktionen zum Aktivieren der Drop-Down-Funktionalität
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

// Funktionen zum Anzeigen und Verbergen des "Lösung anzeigen"-Buttons und der Lösung
function showSolution(solution_button, solution){
    solution_button.style.display = "none";
    solution.style.display = "block";
}

function hideSolution(solution_button, solution){
    solution_button.style.display = "block";
    solution.style.display = "none";
}