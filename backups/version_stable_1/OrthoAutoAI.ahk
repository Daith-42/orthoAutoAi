; OrthoAutoAI v7.3
#Requires AutoHotkey v2.0
#SingleInstance Force

; --- INITIALISATION ---
global ProgramName := "OrthoAutoAI"
global IniFile := "config_OrthoAutoAI.ini"
global StartupLink := A_Startup "\" . ProgramName . ".lnk"
global DesktopLink := A_Desktop "\" . ProgramName . ".lnk"
global Modifiers := ["Alt", "Ctrl", "Shift", "Ctrl + Alt"]
global Modifiers := ["Alt", "Ctrl", "Shift", "Ctrl + Alt"]
global History := []

global Translations := Map(
    "EN", Map(
        "ConfigTitle", "Configuration",
        "HistoryTab", "History",
        "CreditsTab", "Credits",
        "SettingsTab", "Settings",
        "ColTime", "Time",
        "ColOrig", "Original",
        "ColCorr", "Corrected",
        "ApiKeyLabel", "Gemini API Key:",
        "ShortcutCorrect", "Shortcut: Correction",
        "ShortcutSettings", "Shortcut: Settings",
        "LaunchStartup", "Launch OrthoAutoAI at startup",
        "EnableSound", "Enable confirmation beep",
        "EnableConfirm", "Enable manual confirmation",
        "ShowDesktop", "Show shortcut on Desktop",
        "SaveClose", "Save and Close",
        "ResetSettings", "Reset settings",
        "QuitApp", "Quit application",
        "Language", "Language",
        "HelpTitle", "API Key Configuration",
        "HelpText", "Follow these 4 steps:`n`n1. Open Google AI Studio.`n2. Click 'Get API Key'.`n3. Click 'Create API Key' and copy the code.`n4. Paste this code in the 'API Key' field.",
        "Close", "Close",
        "ShortcutActivated", "🚀 Shortcut activated...",
        "NoTextError", "⚠️ Error: No text selected or copy failed.",
        "Analyzing", ": Analyzing... ⏳",
        "Done", "✅ Done!",
        "ApiError", "❌ API Error: ",
        "QuotaExceeded", "⚠️ Error: Quota exceeded. Please wait.",
        "ScriptError", "❌ Script Error",
        "CritError", "Critical Error: ",
        "Saved", "✅ Saved! Reloading...",
        "ResetConfirm", "Delete all settings?",
        "ResetTitle", "Reset",
        "MenuConfig", "⚙ Configuration",
        "Prompt", "Act as a spelling and grammar corrector. Correct this text. Reply ONLY with the corrected text: ",
        "HelpLink", "Link",
        "Success", "Success",
        "ShortcutCreated", "Shortcut created on Desktop:",
        "CreditsContent", "OrthoAutoAI v7.3`n`nCreated by: Daith_42`nDate: January 2026`n`nPowered by Google Gemini AI",
        "VisitWebsite", "Visit Website",
        "ConfirmTitle", "Confirm Correction",
        "BtnApply", "Apply",
        "BtnCancel", "Cancel"
    ),
    "FR", Map(
        "ConfigTitle", "Configuration",
        "HistoryTab", "Historique",
        "CreditsTab", "Crédits",
        "SettingsTab", "Réglages",
        "ColTime", "Heure",
        "ColOrig", "Original",
        "ColCorr", "Corrigé",
        "ApiKeyLabel", "Clé API Gemini :",
        "ShortcutCorrect", "Raccourci : Correction",
        "ShortcutSettings", "Raccourci : Réglages",
        "LaunchStartup", "Lancer OrthoAutoAI au démarrage",
        "EnableSound", "Activer le bip sonore de confirmation",
        "EnableConfirm", "Activer la confirmation manuelle",
        "ShowDesktop", "Afficher le raccourci sur le Bureau",
        "SaveClose", "Sauvegarder et Fermer",
        "ResetSettings", "Réinitialiser les réglages",
        "QuitApp", "Quitter l'application",
        "Language", "Langue",
        "HelpTitle", "Configuration de la clé API",
        "HelpText", "Suivez ces 4 étapes :`n`n1. Ouvrez Google AI Studio.`n2. Cliquez sur 'Get API Key'.`n3. Cliquez sur 'Create API Key' et copiez le code.`n4. Collez ce code dans le champ 'Clé API'.",
        "Close", "Fermer",
        "ShortcutActivated", "🚀 Raccourci activé...",
        "NoTextError", "⚠️ Erreur : Aucun texte sélectionné ou copie impossible.",
        "Analyzing", " : Analyse... ⏳",
        "Done", "✅ Terminé !",
        "ApiError", "❌ Erreur API : ",
        "QuotaExceeded", "⚠️ Erreur : Quota dépassé. Veuillez patienter.",
        "ScriptError", "❌ Erreur Script",
        "CritError", "Erreur critique : ",
        "Saved", "✅ Sauvegardé ! Rechargement...",
        "ResetConfirm", "Supprimer tous les réglages ?",
        "ResetTitle", "Réinitialisation",
        "MenuConfig", "⚙ Configuration",
        "Prompt", "Agis comme un correcteur orthographique et grammatical. Corrige ce texte. Réponds UNIQUEMENT par le texte corrigé : ",
        "HelpLink", "Lien",
        "Success", "Succès",
        "ShortcutCreated", "Raccourci créé sur le bureau logicel :",
        "CreditsContent", "OrthoAutoAI v7.3`n`nCréé par : Daith_42`nDate : Janvier 2026`n`nPropulsé par Google Gemini AI",
        "VisitWebsite", "Visiter le site Web",
        "ConfirmTitle", "Confirmer la correction",
        "BtnApply", "Appliquer",
        "BtnCancel", "Annuler"
    ),
    "ES", Map(
        "ConfigTitle", "Configuración",
        "HistoryTab", "Historial",
        "CreditsTab", "Créditos",
        "SettingsTab", "Ajustes",
        "ColTime", "Hora",
        "ColOrig", "Original",
        "ColCorr", "Corregido",
        "ApiKeyLabel", "Clave API Gemini:",
        "ShortcutCorrect", "Atajo: Corrección",
        "ShortcutSettings", "Atajo: Ajustes",
        "LaunchStartup", "Iniciar OrthoAutoAI al inicio",
        "EnableSound", "Activar pitido de confirmación",
        "EnableConfirm", "Activar confirmación manual",
        "ShowDesktop", "Mostrar acceso directo en Escritorio",
        "SaveClose", "Guardar y Cerrar",
        "ResetSettings", "Restablecer ajustes",
        "QuitApp", "Salir de la aplicación",
        "Language", "Idioma",
        "HelpTitle", "Configuración de Clave API",
        "HelpText", "Sigue estos 4 pasos:`n`n1. Abre Google AI Studio.`n2. Haz clic en 'Get API Key'.`n3. Haz clic en 'Create API Key' y copia el código.`n4. Pega este código en el campo 'Clave API'.",
        "Close", "Cerrar",
        "ShortcutActivated", "🚀 Atajo activado...",
        "NoTextError", "⚠️ Error: No hay texto seleccionado o fallo al copiar.",
        "Analyzing", ": Analizando... ⏳",
        "Done", "✅ ¡Hecho!",
        "ApiError", "❌ Error API: ",
        "QuotaExceeded", "⚠️ Error: Cuota excedida. Por favor espere.",
        "ScriptError", "❌ Error del Script",
        "CritError", "Error Crítico: ",
        "Saved", "✅ ¡Guardado! Recargando...",
        "ResetConfirm", "¿Borrar todos los ajustes?",
        "ResetTitle", "Restablecer",
        "MenuConfig", "⚙ Configuración",
        "Prompt", "Actúa como un corrector ortográfico y gramatical. Corrige este texto. Responde ÚNICAMENTE con el texto corregido: ",
        "HelpLink", "Enlace",
        "Success", "Éxito",
        "ShortcutCreated", "Acceso directo creado en el Escritorio:",
        "CreditsContent", "OrthoAutoAI v7.3`n`nCreado por: Daith_42`nFecha: Enero 2026`n`nImpulsado por Google Gemini AI",
        "VisitWebsite", "Visitar sitio web",
        "ConfirmTitle", "Confirmar corrección",
        "BtnApply", "Aplicar",
        "BtnCancel", "Cancelar"
    ),
    "DE", Map(
        "ConfigTitle", "Konfiguration",
        "HistoryTab", "Verlauf",
        "CreditsTab", "Credits",
        "SettingsTab", "Einstellungen",
        "ColTime", "Zeit",
        "ColOrig", "Original",
        "ColCorr", "Korrigiert",
        "ApiKeyLabel", "Gemini API-Schlüssel:",
        "ShortcutCorrect", "Tastenkürzel: Korrektur",
        "ShortcutSettings", "Tastenkürzel: Einstellungen",
        "LaunchStartup", "OrthoAutoAI beim Start laden",
        "EnableSound", "Bestätigungston aktivieren",
        "EnableConfirm", "Manuelle Bestätigung aktivieren",
        "ShowDesktop", "Verknüpfung auf dem Desktop anzeigen",
        "SaveClose", "Speichern und Schließen",
        "ResetSettings", "Einstellungen zurücksetzen",
        "QuitApp", "Anwendung beenden",
        "Language", "Sprache",
        "HelpTitle", "API-Schlüssel Konfiguration",
        "HelpText", "Folgen Sie diesen 4 Schritten:`n`n1. Öffnen Sie Google AI Studio.`n2. Klicken Sie auf 'Get API Key'.`n3. Klicken Sie auf 'Create API Key' und kopieren Sie den Code.`n4. Fügen Sie diesen Code in das Feld 'API-Schlüssel' ein.",
        "Close", "Schließen",
        "ShortcutActivated", "🚀 Tastenkürzel aktiviert...",
        "NoTextError", "⚠️ Fehler: Kein Text ausgewählt oder Kopieren fehlgeschlagen.",
        "Analyzing", ": Analysieren... ⏳",
        "Done", "✅ Fertig!",
        "ApiError", "❌ API-Fehler: ",
        "QuotaExceeded", "⚠️ Fehler: Kontingent überschritten. Bitte warten.",
        "ScriptError", "❌ Skriptfehler",
        "CritError", "Kritischer Fehler: ",
        "Saved", "✅ Gespeichert! Neustart...",
        "ResetConfirm", "Alle Einstellungen löschen?",
        "ResetTitle", "Zurücksetzen",
        "MenuConfig", "⚙ Konfiguration",
        "Prompt", "Agiere als Rechtschreib- und Grammatikprüfer. Korrigiere diesen Text. Antworte NUR mit dem korrigierten Text: ",
        "HelpLink", "Link",
        "Success", "Erfolg",
        "ShortcutCreated", "Verknüpfung auf dem Desktop erstellt:",
        "CreditsContent", "OrthoAutoAI v7.3`n`nErstellt von: Daith_42`nDatum: Januar 2026`n`nUnterstützt von Google Gemini AI",
        "VisitWebsite", "Website besuchen",
        "ConfirmTitle", "Korrektur bestätigen",
        "BtnApply", "Anwenden",
        "BtnCancel", "Abbrechen"
    ),
    "IT", Map(
        "ConfigTitle", "Configurazione",
        "HistoryTab", "Cronologia",
        "CreditsTab", "Crediti",
        "SettingsTab", "Impostazioni",
        "ColTime", "Ora",
        "ColOrig", "Originale",
        "ColCorr", "Corretto",
        "ApiKeyLabel", "Chiave API Gemini:",
        "ShortcutCorrect", "Scorciatoia: Correzione",
        "ShortcutSettings", "Scorciatoia: Impostazioni",
        "LaunchStartup", "Avvia OrthoAutoAI all'avvio",
        "EnableSound", "Abilita beep di conferma",
        "EnableConfirm", "Abilita conferma manuale",
        "ShowDesktop", "Mostra collegamento sul Desktop",
        "SaveClose", "Salva e Chiudi",
        "ResetSettings", "Ripristina impostazioni",
        "QuitApp", "Esci dall'applicazione",
        "Language", "Lingua",
        "HelpTitle", "Configurazione Chiave API",
        "HelpText", "Segui questi 4 passaggi:`n`n1. Apri Google AI Studio.`n2. Clicca su 'Get API Key'.`n3. Clicca su 'Create API Key' e copia il codice.`n4. Incolla questo codice nel campo 'Chiave API'.",
        "Close", "Chiudi",
        "ShortcutActivated", "🚀 Scorciatoia attivata...",
        "NoTextError", "⚠️ Errore: Nessun testo selezionato o copia fallita.",
        "Analyzing", ": Analisi... ⏳",
        "Done", "✅ Fatto!",
        "ApiError", "❌ Errore API: ",
        "QuotaExceeded", "⚠️ Errore: Quota superata. Attendere prego.",
        "ScriptError", "❌ Errore Script",
        "CritError", "Errore Critico: ",
        "Saved", "✅ Salvato! Ricaricamento...",
        "ResetConfirm", "Cancellare tutte le impostazioni?",
        "ResetTitle", "Ripristina",
        "MenuConfig", "⚙ Configurazione",
        "Prompt", "Agisci come correttore ortografico e grammaticale. Correggi questo testo. Rispondi SOLO con il testo corretto: ",
        "HelpLink", "Link",
        "Success", "Successo",
        "ShortcutCreated", "Collegamento creato sul Desktop:",
        "CreditsContent", "OrthoAutoAI v7.3`n`nCreato da: Daith_42`nData: Gennaio 2026`n`nPowered by Google Gemini AI",
        "VisitWebsite", "Visita il sito web",
        "ConfirmTitle", "Conferma correzione",
        "BtnApply", "Applica",
        "BtnCancel", "Annulla"
    ),
    "PT", Map(
        "ConfigTitle", "Configuração",
        "HistoryTab", "Histórico",
        "CreditsTab", "Créditos",
        "SettingsTab", "Configurações",
        "ColTime", "Hora",
        "ColOrig", "Original",
        "ColCorr", "Corrigido",
        "ApiKeyLabel", "Chave API Gemini:",
        "ShortcutCorrect", "Atalho: Correção",
        "ShortcutSettings", "Atalho: Configurações",
        "LaunchStartup", "Iniciar OrthoAutoAI na inicialização",
        "EnableSound", "Ativar bipe de confirmação",
        "EnableConfirm", "Ativar confirmação manual",
        "ShowDesktop", "Mostrar atalho na Área de Trabalho",
        "SaveClose", "Salvar e Fechar",
        "ResetSettings", "Redefinir configurações",
        "QuitApp", "Sair do aplicativo",
        "Language", "Idioma",
        "HelpTitle", "Configuração da Chave API",
        "HelpText", "Siga estas 4 etapas:`n`n1. Abra o Google AI Studio.`n2. Clique em 'Get API Key'.`n3. Clique em 'Create API Key' e copie o código.`n4. Cole este código no campo 'Chave API'.",
        "Close", "Fechar",
        "ShortcutActivated", "🚀 Atalho ativado...",
        "NoTextError", "⚠️ Erro: Nenhum texto selecionado ou falha ao copiar.",
        "Analyzing", ": Analisando... ⏳",
        "Done", "✅ Feito!",
        "ApiError", "❌ Erro de API: ",
        "QuotaExceeded", "⚠️ Erro: Cota excedida. Aguarde.",
        "ScriptError", "❌ Erro de Script",
        "CritError", "Erro Crítico: ",
        "Saved", "✅ Salvo! Recarregando...",
        "ResetConfirm", "Excluir todas as configurações?",
        "ResetTitle", "Redefinir",
        "MenuConfig", "⚙ Configuração",
        "Prompt", "Atue como um corretor ortográfico e gramatical. Corrija este texto. Responda APENAS com o texto corrigido: ",
        "HelpLink", "Link",
        "Success", "Sucesso",
        "ShortcutCreated", "Atalho criado na Área de Trabalho:",
        "CreditsContent", "OrthoAutoAI v7.3`n`nCriado por: Daith_42`nData: Janeiro 2026`n`nPowered by Google Gemini AI",
        "VisitWebsite", "Visitar site",
        "ConfirmTitle", "Confirmar correção",
        "BtnApply", "Aplicar",
        "BtnCancel", "Cancelar"
    ),
    "RO", Map(
        "ConfigTitle", "Configurare",
        "HistoryTab", "Istoric",
        "CreditsTab", "Credite",
        "SettingsTab", "Setări",
        "ColTime", "Ora",
        "ColOrig", "Original",
        "ColCorr", "Corectat",
        "ApiKeyLabel", "Cheie API Gemini:",
        "ShortcutCorrect", "Scurtătură: Corecție",
        "ShortcutSettings", "Scurtătură: Setări",
        "LaunchStartup", "Lansează OrthoAutoAI la pornire",
        "EnableSound", "Activează bip confirmare",
        "EnableConfirm", "Activează confirmare manuală",
        "ShowDesktop", "Afișează scurtătură pe Desktop",
        "SaveClose", "Salvează și Închide",
        "ResetSettings", "Resetează setările",
        "QuitApp", "Închide aplicația",
        "Language", "Limbă",
        "HelpTitle", "Configurare Cheie API",
        "HelpText", "Urmează acești 4 pași:`n`n1. Deschide Google AI Studio.`n2. Apasă pe 'Get API Key'.`n3. Apasă pe 'Create API Key' și copiază codul.`n4. Lipește acest cod în câmpul 'Cheie API'.",
        "Close", "Închide",
        "ShortcutActivated", "🚀 Scurtătură activată...",
        "NoTextError", "⚠️ Eroare: Niciun text selectat sau copiere eșuată.",
        "Analyzing", ": Analiză... ⏳",
        "Done", "✅ Gata!",
        "ApiError", "❌ Eroare API: ",
        "QuotaExceeded", "⚠️ Eroare: Cotă depășită. Vă rugăm așteptați.",
        "ScriptError", "❌ Eroare Script",
        "CritError", "Eroare Critică: ",
        "Saved", "✅ Salvat! Reîncărcare...",
        "ResetConfirm", "Ștergi toate setările?",
        "ResetTitle", "Resetare",
        "MenuConfig", "⚙ Configurare",
        "Prompt", "Acționează ca un corector ortografic și gramatical. Corectează acest text. Răspunde DOAR cu textul corectat: ",
        "HelpLink", "Link",
        "Success", "Succes",
        "ShortcutCreated", "Scurtătură creată pe Desktop:",
        "CreditsContent", "OrthoAutoAI v7.3`n`nCreat de: Daith_42`nData: Ianuarie 2026`n`nPowered by Google Gemini AI",
        "VisitWebsite", "Vizitează site-ul",
        "ConfirmTitle", "Confirmă corecția",
        "BtnApply", "Aplică",
        "BtnCancel", "Anulează"
    )
)

LoadSettings()

GetText(Key) {
    if (Translations.Has(Language) && Translations[Language].Has(Key))
        return Translations[Language][Key]
    return Translations["FR"][Key] ; Fallback
}

; --- CONFIGURATION DU MENU TRAY (CLIC DROIT & DOUBLE-CLIC) ---
A_TrayMenu.Add() ; Ligne de séparation
A_TrayMenu.Add(GetText("MenuConfig"), ShowGui)
A_TrayMenu.Default := GetText("MenuConfig") ; Définit l'action du double-clic
A_TrayMenu.ClickCount := 2 ; Force la détection du double-clic (et non simple)

; --- VÉRIFICATION DE DÉMARRAGE (ONBOARDING) ---
if (API_KEY == "") {
    ShowGui()
    HelpApiKey()
} else if (A_Args.Length == 0 || A_Args[1] != "--startup") {
    ShowGui()
}

; --- RACCOURCIS ---
try {
    Hotkey(MainHotkey, ActionIA)
    Hotkey(SettingsHotkey, ShowGui)
} catch {
    Hotkey("!c", ActionIA) 
    Hotkey("!w", ShowGui)
}

; --- MOTEUR DE CORRECTION IA (MODE DEBUG) ---
ActionIA(HotkeyName) {
    global API_KEY, MODEL, IsSoundEnabled, DailyCount
    
    if (API_KEY == "") {
        MsgBox("La clé API est absente. Veuillez configurer le script.", ProgramName, "Icon! 0x1000")
        ShowGui()
        return
    }

    ToolTip(GetText("ShortcutActivated"))
    OldClipboard := A_Clipboard
    A_Clipboard := "" 
    Send("^c")
    if !ClipWait(1.5) {
        ToolTip(GetText("NoTextError"))
        SetTimer () => ToolTip(), -3000
        return
    }
    OriginalText := A_Clipboard

    ToolTip(ProgramName . GetText("Analyzing"))
    
    ; OPTIMISATION : Prompt minimaliste (Correction uniquement)
    SystemPrompt := GetText("Prompt")

    CleanText := StrReplace(StrReplace(A_Clipboard, '"', '\"'), '`n', '\n')
    Payload := '{ "contents": [{ "parts": [{ "text": "' . SystemPrompt . CleanText . '" }] }] }'
    
    URL := "https://generativelanguage.googleapis.com/v1/models/" . MODEL . ":generateContent?key=" . API_KEY
    
    try {
        Http := ComObject("WinHttp.WinHttpRequest.5.1")
        Http.Open("POST", URL, true)
        Http.SetRequestHeader("Content-Type", "application/json")
        Http.Send(Payload)
        
        ; Timeout retiré pour stabilité
        Http.WaitForResponse()
        
        if (Http.Status == 200 && RegExMatch(Http.ResponseText, '"text":\s*"(.*?)(?<!\\)"', &Match)) {
            Result := StrReplace(StrReplace(Match[1], '\"', '"'), '\n', '`n')
            
            ; --- CONFIRMATION MANUELLE ---
            if (IsConfirmEnabled) {
                Result := AskConfirmation(OriginalText, Result)
                if (Result == "") {
                    ToolTip(GetText("BtnCancel"))
                    SetTimer () => ToolTip(), -1500
                    A_Clipboard := OldClipboard
                    return
                }
            }
            
            A_Clipboard := Result
            if !ClipWait(1) { ; ClipWait réduit
                ToolTip("⚠️ Erreur Presse-papier")
                return
            }
            
            Sleep(50) ; Délai optimisé
            Send("^v") 
            Sleep(50) ; Délai optimisé
            
            ToolTip(GetText("Done"))
            if (IsSoundEnabled) {
                SoundBeep(800, 100)
            }
            
            ; Mise à jour Compteur
            DailyCount++
            IniWrite(DailyCount, IniFile, "Stats", "DailyCount")
            IniWrite(FormatTime(, "yyyyMMdd"), IniFile, "Stats", "LastDate")

            ; Historique
            History.InsertAt(1, {Time: FormatTime(, "HH:mm"), Orig: OriginalText, Corr: Result})
            if (History.Length > 5)
                History.Pop()
            
        } else if (Http.Status == 429) {
            ToolTip(GetText("QuotaExceeded"))
            SetTimer () => ToolTip(), -3500
        } else {
            ToolTip(GetText("ApiError") . Http.Status)
            SetTimer () => ToolTip(), -2000
        }
    } catch Error as e {
        ToolTip(GetText("ScriptError"))
        MsgBox(GetText("CritError") . e.Message, ProgramName, "Icon! 0x1000")
    }
    SetTimer () => ToolTip(), -1500
    Sleep(500) ; Restauration plus rapide (était 1000)
    try {
        A_Clipboard := OldClipboard
    }
}

AskConfirmation(Original, Corrected) {
    Confirmed := false
    
    CnfGui := Gui("+AlwaysOnTop", GetText("ConfirmTitle"))
    CnfGui.SetFont("s10", "Segoe UI")
    
    CnfGui.Add("Text", "w400", GetText("ColOrig") . ":")
    CnfGui.Add("Edit", "w400 h100 +ReadOnly +Multi", Original)
    
    CnfGui.Add("Text", "w400 y+10", GetText("ColCorr") . ":")
    EditCorr := CnfGui.Add("Edit", "w400 h100 +Multi", Corrected)
    
    GlobalRes := ""
    
    Apply(*) {
        GlobalRes := EditCorr.Value
        CnfGui.Destroy()
    }
    
    CnfGui.Add("Button", "w190 y+10 Default", GetText("BtnApply")).OnEvent("Click", Apply)
    CnfGui.Add("Button", "x+10 w190", GetText("BtnCancel")).OnEvent("Click", (*) => CnfGui.Destroy())
    
    CnfGui.Show()
    WinWaitClose(CnfGui)
    
    return GlobalRes
}

; --- PANNEAU DE CONFIGURATION ---
ShowGui(*) {
    global MyGui := Gui("+AlwaysOnTop", ProgramName . " - " . GetText("ConfigTitle"))
    MyGui.SetFont("s10", "Segoe UI")


    Tabs := MyGui.Add("Tab3", "w360 h460", [GetText("SettingsTab"), GetText("HistoryTab"), GetText("CreditsTab")])
    
    ; --- TAB 1: SETTINGS ---
    Tabs.UseTab(1)
    
    MyGui.Add("Text", "x20 y+15", GetText("ApiKeyLabel"))
    global EditApi := MyGui.Add("Edit", "w280 h24", API_KEY)
    MyGui.Add("Button", "x+5 yp-1 w26 h26", "i").OnEvent("Click", HelpApiKey)

    MyGui.Add("GroupBox", "x20 w320 h80 y+15", GetText("ShortcutCorrect"))
    global DropMainMod := MyGui.Add("DropDownList", "xp+15 yp+35 w100 h30 r5 Choose" . GetIdxHk(MainHotkey), Modifiers)
    MyGui.Add("Text", "x+8 yp+4", "+") 
    global EditMainKey := MyGui.Add("Edit", "x+8 yp-4 w45 h24 Limit1 Uppercase Center", GetKey(MainHotkey))

    MyGui.Add("GroupBox", "x20 w320 h80 y+20", GetText("ShortcutSettings"))
    global DropSetMod := MyGui.Add("DropDownList", "xp+15 yp+30 w100 h30 r5 Choose" . GetIdxHk(SettingsHotkey), Modifiers)
    MyGui.Add("Text", "x+8 yp+4", "+")
    global EditSetKey := MyGui.Add("Edit", "x+8 yp-4 w45 h24 Limit1 Uppercase Center", GetKey(SettingsHotkey))
    
    ; Langue
    MyGui.Add("Text", "x20 y+25", GetText("Language") . " :")
    Langs := ["English", "Français", "Español", "Deutsch", "Italiano", "Português", "Română"]
    global DropLang := MyGui.Add("DropDownList", "x+10 yp-3 w120 Choose" . GetLangIndex(Language), Langs)

    global CheckStart := MyGui.Add("Checkbox", "x25 y+25 " . (FileExist(StartupLink) ? "Checked" : ""), GetText("LaunchStartup"))
    global CheckSound := MyGui.Add("Checkbox", "x25 y+10 " . (IsSoundEnabled ? "Checked" : ""), GetText("EnableSound"))
    global CheckConfirm := MyGui.Add("Checkbox", "x25 y+10 " . (IsConfirmEnabled ? "Checked" : ""), GetText("EnableConfirm"))
    global CheckDesktop := MyGui.Add("Checkbox", "x25 y+10 " . (FileExist(DesktopLink) ? "Checked" : ""), GetText("ShowDesktop"))

    ; --- TAB 2: HISTORY ---
    Tabs.UseTab(2)
    
    LogContent := ""
    if (History.Length == 0) {
        LogContent := "Aucun historique pour le moment."
    } else {
        for Item in History {
            LogContent .= "[" . Item.Time . "]`r`n"
            LogContent .= "Original : " . Item.Orig . "`r`n"
            LogContent .= "Corrigé  : " . Item.Corr . "`r`n"
            LogContent .= "--------------------------------------------------`r`n"
        }
    }

    global HistEdit := MyGui.Add("Edit", "x20 y+15 w320 h380 +ReadOnly +Multi -VScroll", LogContent) ;; -VScroll let AHK handle it or just +VScroll? +VScroll is better for log.
    ;; Actually default Edit has scroll if needed. Let's force vertical scrollbar if content large? 
    ;; Let's use standard.
    
    ; --- TAB 3: CREDITS ---
    Tabs.UseTab(3)
    MyGui.SetFont("s10", "Segoe UI")
    MyGui.Add("Text", "x20 y+20 w320 Center", GetText("CreditsContent"))
    MyGui.Add("Link", "x20 y+15 w320 Center", '<a href="https://www.orthoautoai.com">' . GetText("VisitWebsite") . '</a>')
    MyGui.SetFont("s10", "Segoe UI") ; Reset font if needed

    ; --- FOOTER (OUTSIDE TABS) ---
    Tabs.UseTab()
    Tabs.GetPos(,&Ty, ,&Th) ; Récupère la position et hauteur des Onglets
    FooterY := Ty + Th + 10

    MyGui.Add("Button", "x10 y" . FooterY . " w360 Default", GetText("SaveClose")).OnEvent("Click", (*) => SaveData())
    MyGui.Add("Button", "x10 y+10 w360", GetText("ResetSettings")).OnEvent("Click", ResetDefaults)
    MyGui.Add("Button", "x10 y+10 w360", GetText("QuitApp")).OnEvent("Click", (*) => ExitApp())
    MyGui.Show()
}

; --- FENÊTRES D'AIDE ---
HelpApiKey(*) {
    HelpGui := Gui("+AlwaysOnTop", GetText("HelpTitle"))
    HelpGui.SetFont("s10")
    HelpGui.Add("Text", "w350", GetText("HelpText"))
    HelpGui.Add("Link", "y+15", GetText("HelpLink") . ' : <a href="https://aistudio.google.com/app/apikey">Google AI Studio (Gratuit)</a>')
    HelpGui.Add("Button", "y+20 w80", GetText("Close")).OnEvent("Click", (*) => HelpGui.Destroy())
    HelpGui.Show()
}

    AskLanguage() {
    LangGui := Gui("+AlwaysOnTop -SysMenu", "Language")
    LangGui.SetFont("s10", "Segoe UI")
    LangGui.Add("Text", "Center w250", "Please select your language:")
    
    Langs := ["English", "Français", "Español", "Deutsch", "Italiano", "Português", "Română"]
    ddl := LangGui.Add("DropDownList", "x35 y+10 w180 Choose1", Langs)
    
    Confirm(*) {
        IniWrite(GetCodeFromLang(ddl.Text), IniFile, "Settings", "Language")
        LangGui.Destroy()
    }

    LangGui.Add("Button", "x85 y+20 w80 Default", "OK").OnEvent("Click", Confirm)
    LangGui.Show()
    WinWaitClose(LangGui)
}



; --- LOGIQUE TECHNIQUE ---
SaveData() {
    global API_KEY, IsSoundEnabled, IsConfirmEnabled, MainHotkey, SettingsHotkey, Language

    if (CheckStart.Value) {
        FileCreateShortcut(A_ScriptFullPath, StartupLink,, "--startup")
    } else {
        try FileDelete(StartupLink)
    }

    if (CheckDesktop.Value) {
        FileCreateShortcut(A_ScriptFullPath, DesktopLink)
    } else {
        try FileDelete(DesktopLink)
    }

    ; --- Sauvegarde INI ---
    NewApi := EditApi.Value
    NewSound := CheckSound.Value
    NewConfirm := CheckConfirm.Value
    NewMain := ToSymb(DropMainMod.Text) . EditMainKey.Value
    NewSet := ToSymb(DropSetMod.Text) . EditSetKey.Value
    NewLang := GetCodeFromLang(DropLang.Text)

    IniWrite(NewApi, IniFile, "Settings", "ApiKey")
    IniWrite(NewSound, IniFile, "Settings", "IsSoundEnabled")
    IniWrite(NewConfirm, IniFile, "Settings", "IsConfirmEnabled")
    IniWrite(NewMain, IniFile, "Settings", "MainHotkey")
    IniWrite(NewSet, IniFile, "Settings", "SettingsHotkey")
    IniWrite(NewLang, IniFile, "Settings", "Language")

    ; Si la langue change, on doit recharger le script pour mettre à jour l'interface
    if (NewLang != Language) {
        ToolTip(GetText("Saved"))
        Sleep(1000)
        Reload()
        return
    }

    ; --- Application immédiate des changements ---
    API_KEY := NewApi
    IsSoundEnabled := NewSound
    IsConfirmEnabled := NewConfirm
    Language := NewLang

    ; Mise à jour des raccourcis si changés
    if (NewMain != MainHotkey) {
        try Hotkey(MainHotkey, "Off")
        try Hotkey(NewMain, ActionIA, "On")
        MainHotkey := NewMain
    }

    if (NewSet != SettingsHotkey) {
        try Hotkey(SettingsHotkey, "Off")
        try Hotkey(NewSet, ShowGui, "On")
        SettingsHotkey := NewSet
    }

    ; Fermeture propre
    MyGui.Destroy()
    ToolTip(GetText("Saved"))
    SetTimer () => ToolTip(), -1500
}

ResetDefaults(*) {
    if (MsgBox(GetText("ResetConfirm"), GetText("ResetTitle"), "YesNo Icon! 0x1000") == "Yes") {
        try FileDelete(IniFile)
        try FileDelete(StartupLink)
        Reload()
    }
}

GetIdxHk(hk) {
    if (InStr(hk, "^!") == 1)
        return 4
    if (InStr(hk, "!") == 1)
        return 1
    if (InStr(hk, "^") == 1)
        return 2
    if (InStr(hk, "+") == 1)
        return 3
    return 1
}



GetKey(hk) => RegExReplace(hk, "[!^+]", "")

ToSymb(name) {
    switch name {
        case "Alt": return "!"
        case "Ctrl": return "^"
        case "Shift": return "+"
        case "Ctrl + Alt": return "^!"
        default: return "!"
    }
}

GetLangIndex(Code) {
    switch Code {
        case "EN": return 1
        case "FR": return 2
        case "ES": return 3
        case "DE": return 4
        case "IT": return 5
        case "PT": return 6
        case "RO": return 7
        default: return 1
    }
}

GetCodeFromLang(Name) {
    switch Name {
        case "English": return "EN"
        case "Français": return "FR"
        case "Español": return "ES"
        case "Deutsch": return "DE"
        case "Italiano": return "IT"
        case "Português": return "PT"
        case "Română": return "RO"
        default: return "EN"
    }
}



LoadSettings() {
    global API_KEY := IniRead(IniFile, "Settings", "ApiKey", "")
    global MODEL := IniRead(IniFile, "Settings", "Model", "gemini-2.5-flash")
    global MainHotkey := IniRead(IniFile, "Settings", "MainHotkey", "!c")
    global SettingsHotkey := IniRead(IniFile, "Settings", "SettingsHotkey", "!w")
    global IsSoundEnabled := IniRead(IniFile, "Settings", "IsSoundEnabled", 0)
    global IsConfirmEnabled := IniRead(IniFile, "Settings", "IsConfirmEnabled", 0)

    
    ; Vérification Langue (Premier démarrage)
    LangCheck := IniRead(IniFile, "Settings", "Language", "MISSING")
    if (LangCheck == "MISSING") {
        AskLanguage()
        LangCheck := IniRead(IniFile, "Settings", "Language", "EN")
    }
    global Language := LangCheck
    
    ; Stats
    global DailyCount := IniRead(IniFile, "Stats", "DailyCount", 0)
    global LastDate := IniRead(IniFile, "Stats", "LastDate", FormatTime(, "yyyyMMdd"))
    
    ; Reset quotidien si la date a changé
    if (LastDate != FormatTime(, "yyyyMMdd")) {
        DailyCount := 0
        LastDate := FormatTime(, "yyyyMMdd")
        IniWrite(DailyCount, IniFile, "Stats", "DailyCount")
        IniWrite(LastDate, IniFile, "Stats", "LastDate")
    }
}
