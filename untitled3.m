function nyquist_GUI
    % Cr�er la figure principale
    fig = figure('Name', 'Analyse des Diagrammes de Nyquist, Bode et Black', 'NumberTitle', 'off', ...
                'Position', [100, 100, 1300, 700], 'Color', [0.95 0.95 0.95]);
    
    % Panneau pour les entr�es utilisateur (plac� en haut)
    panel = uipanel('Title', 'Entr�e de la Fonction de Transfert', 'FontSize', 12, ...
                    'FontWeight', 'bold', 'BackgroundColor', [0.85 0.85 0.85], ...
                    'Position', [0.02, 0.75, 0.96, 0.2]);  

    % S�lection de l'ordre du syst�me
    uicontrol(panel, 'Style', 'text', 'Position', [20, 50, 120, 25], 'String', 'Ordre du syst�me :', ...
              'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', [0.85 0.85 0.85]);
    order_menu = uicontrol(panel, 'Style', 'popupmenu', 'Position', [20, 20, 120, 30], 'FontSize', 10, ...
                           'String', {'1', '2', '3', '4', '5'}, 'Callback', @updateDenInput);
    
    % Num�rateur
    uicontrol(panel, 'Style', 'text', 'Position', [160, 50, 100, 25], 'String', 'Num�rateur :', ...
              'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', [0.85 0.85 0.85]);
    num_input = uicontrol(panel, 'Style', 'edit', 'Position', [160, 20, 150, 30], 'String', '1', 'FontSize', 10);
    
    % D�nominateur
    uicontrol(panel, 'Style', 'text', 'Position', [330, 50, 100, 25], 'String', 'D�nominateur :', ...
              'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', [0.85 0.85 0.85]);
    den_input = uicontrol(panel, 'Style', 'edit', 'Position', [330, 20, 150, 30], 'String', '1 1', 'FontSize', 10);
    
    % Fonction de transfert
    uicontrol(panel, 'Style', 'text', 'Position', [500, 50, 180, 25], 'String', 'Fonction de transfert :', ...
              'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', [0.85 0.85 0.85]);
    tf_display = uicontrol(panel, 'Style', 'text', 'Position', [500, 20, 250, 30], 'FontSize', 10, ...
                           'BackgroundColor', [1, 1, 1], 'String', 'H(s)');
    
    % Type de simulation
    uicontrol(panel, 'Style', 'text', 'Position', [780, 50, 180, 25], 'String', 'Type de simulation :', ...
              'FontSize', 10, 'FontWeight', 'bold', 'BackgroundColor', [0.85 0.85 0.85]);
    sim_type = uicontrol(panel, 'Style', 'popupmenu', 'Position', [780, 20, 180, 30], 'FontSize', 10, ...
                         'String', {'Boucle ouverte', 'Boucle ferm�e'});

    % Bouton de simulation (orange)
    uicontrol(panel, 'Style', 'pushbutton', 'Position', [1000, 20, 200, 35], 'String', 'Simuler', ...
              'FontSize', 12, 'FontWeight', 'bold', 'ForegroundColor', 'white', 'BackgroundColor', [1 0.5 0], ...
              'Callback', @plotDiagrams);

    % Axes pour les diagrammes (plac�s c�te � c�te)
    ax_nyquist = axes('Units', 'Normalized', 'Position', [0.05, 0.10, 0.28, 0.60]);
    title(ax_nyquist, 'Diagramme de Nyquist', 'FontSize', 12, 'FontWeight', 'bold');
    grid(ax_nyquist, 'on');
    
    ax_bode = axes('Units', 'Normalized', 'Position', [0.37, 0.10, 0.28, 0.60]);
    title(ax_bode, 'Diagramme de Bode', 'FontSize', 12, 'FontWeight', 'bold');
    grid(ax_bode, 'on');
    
    ax_black = axes('Units', 'Normalized', 'Position', [0.69, 0.10, 0.28, 0.60]);
    title(ax_black, 'Diagramme de Black', 'FontSize', 12, 'FontWeight', 'bold');
    grid(ax_black, 'on');

    % Fonction pour mettre � jour la taille du d�nominateur
    function updateDenInput(~, ~)
        order = get(order_menu, 'Value'); % R�cup�rer l'ordre s�lectionn�
        default_den = num2str(ones(1, order)); % G�n�rer un polyn�me par d�faut
        set(den_input, 'String', default_den);
    end

    % Fonction de simulation et affichage des diagrammes
    function plotDiagrams(~, ~)
        % Lire les coefficients
        num = str2num(get(num_input, 'String')); %#ok<ST2NM>
        den = str2num(get(den_input, 'String')); %#ok<ST2NM>
        
        if isempty(num) || isempty(den)
            errordlg('Veuillez entrer des coefficients valides.', 'Erreur');
            return;
        end
        
        sys_open = tf(num, den);
        
        % D�terminer le syst�me selon le type de simulation
        if get(sim_type, 'Value') == 2
            sys = feedback(sys_open, 1);
        else
            sys = sys_open;
        end
        
        % Mettre � jour l'affichage de la fonction de transfert
        [num_str, den_str] = tfToString(num, den);
        set(tf_display, 'String', sprintf('H(s) = %s / %s', num_str, den_str));

        % Tracer les diagrammes
        cla(ax_nyquist);
        axes(ax_nyquist);
        nyquist(sys);
        grid on;
        
        cla(ax_bode);
        axes(ax_bode);
        bode(sys);
        grid on;
        
        cla(ax_black);
        axes(ax_black);
        nichols(sys);
        grid on;
    end

    % Fonction pour convertir les coefficients en une cha�ne de caract�res
    function [num_str, den_str] = tfToString(num, den)
        num_str = poly2str(num, 's');
        den_str = poly2str(den, 's');
    end
end


