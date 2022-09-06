// ÜBERSICHTSLISTEN + LERNEINHEITEN: AUSKLAPPEN/EINKLAPPEN ALLER EBENEN/ELEMENTE

// Initialisieren mit dem Zustand "allClosed" -> Alle Ebenen/Elemente sind zu Beginn eingeklappt/geschlossen
$(".show_collapse_button").data("allClosed", true);

// Ausführen der Funktion bei Klick auf den "Alle Ebenen anzeigen/verbergen"- bzw. "Alle Beispiele/Übungen anzeigen/verbergen"-Button
$(".show_collapse_button").click(function(){
    // Testen, ob der Zustand "allClosed" gegeben ist bzw. ob alle Elemente eingeklappt sind -> Falls ja:
    // Alle Elemente werden ausgeklappt und ihre Chevron-Icons werden mit der "active"-Klasse versehen (für Rotation und Farbwechsel -> Siehe svg_icons.scss-Datei im _sass-Ordner)
    if ($(this).data("allClosed")) {
        $(".list-group").collapse("show");
        $(".rotate_180").addClass("active");
    }
    // Ansonsten, also falls der Zustand "allClosed" nicht gegeben ist bzw. falls nicht alle Elemente bereits eingeklappt sind, sondern es noch ausgeklappte Elemente gibt: 
    // Alle Elemente werden eingeklappt und die "active"-Klasse wird von ihren Chevron-Icons entfernt
    else {
        $(".list-group").collapse("hide");
        $(".rotate_180").removeClass("active");
    }
    // Speichern des letzten Zustands
    $(this).data("allClosed", !$(this).data("allClosed"));
});


// CHEVRON-ICONS: ROTATION/FARBWECHSEL

// Chevron-Rotation/Farbwechsel beim Ausklappen eines Elements -> Dazu: CSS-Styling über die "active"-Klasse (-> Siehe svg_icons.scss-Datei)
// Bei Klick auf das Icon bzw. den Link zum Ausklappen:
$(".chevron_link").click(function(){
    // Finden des Icon-Elements und Hinzufügen der "active"-Klasse (falls sie noch nicht vorhanden ist) oder Entfernen der "active"-Klasse (falls sie bereits vorhanden ist)
    $(this).find(".rotate_180").toggleClass("active"); 
});

// Chevron-Rotation/Farbwechsel beim Öffnen eines Pop-Over-Fensters -> Dazu: CSS-Styling über die "active"-Klasse (-> Siehe svg_icons.scss-Datei)
// Bei Klick auf den Pop-Over-Link:
$(".pop_over_link").click(function(){
    // Finden des Icon-Elements und Hinzufügen der "active"-Klasse (falls sie noch nicht vorhanden ist) oder Entfernen der "active"-Klasse (falls sie bereits vorhanden ist)
    $(this).find(".rotate_90").toggleClass("active"); 
});

// Delegated Event Binding für Pop-Over-Links/Fenster in Übung-Antworten, die beim Laden der Website noch nicht angezeigt werden und erst sichtbar gemacht werden müssen
// (z.B. für die Antwort bei einer MC-Übung, die erst nach einem Klick auf den "Lösung anzeigen"-Button sichtbar wird)
// Das Klick-Event muss in diesem Fall an das übergeordnete <div class="answer">-Element gebunden werden, damit es ausgelöst und die Funktion für die Chevron-Rotation aufgerufen wird
$(".answer").on("click", ".pop_over_link", function(){
    $(this).find(".rotate_90").toggleClass("active"); 
});