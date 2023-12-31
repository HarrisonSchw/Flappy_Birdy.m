clear 
clc

%Initialize variables that are needed to make the game run forever
Never_Ending_1=0;
Never_Ending_2=0;
Easy_Mode=0;

%First never ending loop that allows for game to be play again once lost 
while Never_Ending_1<1
    clc
    %Initialize score variable
    score=0;

    %Generate start screen with instructions on how to play
    ColorPSscreen = [.2 .6 .6];

    backGround = figure('Units','normalized','Position',[.25,.25,.5,.5],'Color',ColorPSscreen,...
    'MenuBar','none','NumberTitle','off','Pointer','hand','Visible','on');

    welcome = uicontrol('Style','text','Units','normalized','Position',[.125,.8,.75,.125],'String',...
    'Welcome to Flappy Birdy!', 'BackgroundColor',ColorPSscreen,...
    'FontSize',22,'FontWeight','bold','ForegroundColor',[.1 0 0]);

    instructions = uicontrol('Style','text','Units','normalized','Position',[.125,.6,.75,.125],'String',...
    "Press up arrow to go up", 'BackgroundColor',ColorPSscreen,...
    'FontSize',12,'FontWeight','bold','ForegroundColor',[.1 0 0]);

    instructions1 = uicontrol('Style','text','Units','normalized','Position',[.125,.5,.75,.125],'String',...
    "Press down arrow to go down", 'BackgroundColor',ColorPSscreen,...
    'FontSize',12,'FontWeight','bold','ForegroundColor',[.1 0 0]);

    instructions2 = uicontrol('Style','text','Units','normalized','Position',[.125,.4,.75,.125],'String',...
    "Press right arrow to stay straight", 'BackgroundColor',ColorPSscreen,...
    'FontSize',12,'FontWeight','bold','ForegroundColor',[.1 0 0]);

    %Place button on start screen that starts game when pressed
    startButton = uicontrol('Style','pushbutton','Units','normalized','Position',[.4,.1,.2,.1],...
    'String','Press To Start','FontSize',11);
    waitforbuttonpress

    %When start button is pressed close start screen
    close(backGround)

    %Load sprites using modified simple game engine
    flappy_Bird=TeamBsimpleGameEngine("pixil-frame-0.png",26,26,5,[1,1,1]);

    %Generate background matrix with rows assigned to proper sprites
    Background=ones(7,15);
    Background(7,:)=Background(7,:)*5;
    Background(6,:)=Background(6,:)*3;
    Background(5,:)=Background(5,:)*2;
    Background(4,:)=Background(4,:)*4;
    Background([1 2 3],:)=Background([1 2 3],:)*9;

    %Generate blank foreground matrix
    Foreground=ones(7,15);

    %Set bird to start in the middle of the matrix
    Bird_Pos=4;

    %Set initial pipe x positions
    Pipe_1_x_position=15;
    Pipe_2_x_position=20;
    Pipe_3_x_position=25;

    %Generate random initial y hight for pipe openings
    Pipe_1_y_position=randperm(5,1);
    Pipe_2_y_position=randperm(5,1);
    Pipe_3_y_position=randperm(5,1);

    %Add 1 to pipe hight so the opening isn't on the top row or bottom row
    Pipe_1_y_position=Pipe_1_y_position+1;
    Pipe_2_y_position=Pipe_2_y_position+1;
    Pipe_3_y_position=Pipe_3_y_position+1;

    %Draw initial scene using background and empty foreground
    drawScene(flappy_Bird,Background,Foreground);

    %Display score in top left of the scene
    scoreText = text(0, 50, ['Score: ', num2str(score)], 'FontSize', 14,  'Color', 'k');

    %Second never ending loop so game can be played forever
    while Never_Ending_2<20
        %Set figure title
        title('Flappy Birdy by Group B');

        %When pipes are on screen generate sprite column matrix based on
        %opening hight and set pipe x position in foreground to column
        %matrix
        if Pipe_1_x_position<=15
          Pipe_Hight_1=Flappypipes(Pipe_1_y_position);
            Foreground(:,Pipe_1_x_position)=Pipe_Hight_1;
        end
        if Pipe_2_x_position<=15
            Pipe_Hight_2=Flappypipes(Pipe_2_y_position);
            Foreground(:,Pipe_2_x_position)=Pipe_Hight_2;
        end
        if Pipe_3_x_position<=15
            Pipe_Hight_3=Flappypipes(Pipe_3_y_position);
            Foreground(:,Pipe_3_x_position)=Pipe_Hight_3;
        end

        %Set score on screen to player score
        set(scoreText, 'String', ['Score: ', num2str(score)]);

        %Increase score if pipe opening hight and bird hieght are the same
        %and their x positions are the same else if the y positions are not
        %the same exit second never ending loop
        if Pipe_1_x_position == 5 & Bird_Pos == Pipe_1_y_position
            score=score+1;
        elseif Pipe_1_x_position == 5 & Bird_Pos ~= Pipe_1_y_position
            break
        end
        if Pipe_2_x_position == 5 & Bird_Pos == Pipe_2_y_position
            score=score+1;
        elseif Pipe_2_x_position == 5 & Bird_Pos ~= Pipe_2_y_position
            break
        end
        if Pipe_3_x_position == 5 & Bird_Pos == Pipe_3_y_position
            score=score+1;
        elseif Pipe_3_x_position == 5 & Bird_Pos ~= Pipe_3_y_position
            break
        end
        
        %Check last pressed button and move brid up or down based on input
        Flap_Key=getKeyboardInput(flappy_Bird);
        Bird_Pos=Flap(Bird_Pos, Flap_Key);

        %Set bird position in foreground to bird sprite number
        Foreground(Bird_Pos,5)=10;
        
        %If player scores 0 points 5 times in a row they enter AFK mode
        %which sets the pipe heights to the birds original height 
        if Easy_Mode==5
            Pipe_1_y_position=Bird_Pos;
            Pipe_2_y_position=Bird_Pos;
            Pipe_3_y_position=Bird_Pos;
            if Pipe_1_x_position<=15
                Pipe_Hight_1=Flappypipes(Pipe_1_y_position);
                Foreground(:,Pipe_1_x_position)=Pipe_Hight_1;
            end
            if Pipe_2_x_position<=15
                Pipe_Hight_2=Flappypipes(Pipe_2_y_position);
                Foreground(:,Pipe_2_x_position)=Pipe_Hight_2;
            end
            if Pipe_3_x_position<=15
                Pipe_Hight_3=Flappypipes(Pipe_3_y_position);
                Foreground(:,Pipe_3_x_position)=Pipe_Hight_3;
            end
            Foreground(Bird_Pos,5)=10;
        end

        %Draw scene using sprites, beckground, and foreground
        drawScene(flappy_Bird,Background,Foreground);
        
        %Set old bird poition in foreground to blank
        Foreground(Bird_Pos,5)=1;

        %Set old pipe positions in foreground columns to blank
        if Pipe_1_x_position<=15
            Foreground(:,Pipe_1_x_position)=ones(7,1);
        end
        if Pipe_2_x_position<=15
            Foreground(:,Pipe_2_x_position)=ones(7,1);
        end
        if Pipe_3_x_position<=15
            Foreground(:,Pipe_3_x_position)=ones(7,1);
        end

        %Shift pipe x position one to the left
        Pipe_1_x_position=Pipe_1_x_position-1;
        Pipe_2_x_position=Pipe_2_x_position-1;
        Pipe_3_x_position=Pipe_3_x_position-1;

        %Check if pipe positions would go off the screen to the left and if
        %teh would reset them to the right side of the screen and generate
        %a new random pipe hieght
        if Pipe_1_x_position<=0
            Pipe_1_x_position=15;
            Pipe_1_y_position=randperm(5,1);
            Pipe_1_y_position=Pipe_1_y_position+1;
        end
        if Pipe_2_x_position<=0
            Pipe_2_x_position=15;
            Pipe_2_y_position=randperm(5,1);
            Pipe_2_y_position=Pipe_2_y_position+1;
        end
        if Pipe_3_x_position<=0
            Pipe_3_x_position=15;
            Pipe_3_y_position=randperm(5,1);
            Pipe_3_y_position=Pipe_3_y_position+1;
        end

        %Check if end button was pressed and exit loop if it was
        if getKeyboardInput(flappy_Bird)=='9'
            break
        end

        %Pause to allow player to react to pipes and simulate movement
        pause(1)
    end

    %Check if end button was pressed and exit loop if it was
    if getKeyboardInput(flappy_Bird)=='9'
        break
    end

    %Create string with score to use in end screen
    final_score="Score: "+score;
  
    %Create end screen
    ColorPSscreen = [.6 .1 .1];
    backGround = figure('Units','normalized','Position',[.25,.25,.5,.5],'Color',ColorPSscreen,...
    'MenuBar','none','NumberTitle','off','Pointer','hand','Visible','on');

    welcome = uicontrol('Style','text','Units','normalized','Position',[.125,.8,.75,.125],'String',...
    'You Died!', 'BackgroundColor',ColorPSscreen,...
    'FontSize',22,'FontWeight','bold','ForegroundColor',[.1 0 0]);
    
        %Depending on what score the player got, display corisponding
        %achievement level
        if score>=80
            score_Disp = uicontrol('Style','text','Units','normalized','Position',[.125,.6,.75,.125],'String',...
            'You are a Platinum Level Player!', 'BackgroundColor',ColorPSscreen,...
            'FontSize',22,'FontWeight','bold','ForegroundColor',[.1 0 0]);
        elseif score>=60
            score_Disp = uicontrol('Style','text','Units','normalized','Position',[.125,.6,.75,.125],'String',...
            'You are a Gold Level Player!', 'BackgroundColor',ColorPSscreen,...
            'FontSize',22,'FontWeight','bold','ForegroundColor',[.1 0 0]);
        elseif score>=40
            score_Disp = uicontrol('Style','text','Units','normalized','Position',[.125,.6,.75,.125],'String',...
            'You are a Silver Level Player!', 'BackgroundColor',ColorPSscreen,...
            'FontSize',22,'FontWeight','bold','ForegroundColor',[.1 0 0]);
        elseif score>=20
            score_Disp = uicontrol('Style','text','Units','normalized','Position',[.125,.6,.75,.125],'String',...
            'You are a Copper Level Player!', 'BackgroundColor',ColorPSscreen,...
            'FontSize',22,'FontWeight','bold','ForegroundColor',[.1 0 0]);
        else
            score_Disp = uicontrol('Style','text','Units','normalized','Position',[.125,.6,.75,.125],'String',...
            'Not Bad! Try Again!', 'BackgroundColor',ColorPSscreen,...
            'FontSize',22,'FontWeight','bold','ForegroundColor',[.1 0 0]);
        end


    score_Disp = uicontrol('Style','text','Units','normalized','Position',[.125,.4,.75,.125],'String',...
    final_score, 'BackgroundColor',ColorPSscreen,...
    'FontSize',22,'FontWeight','bold','ForegroundColor',[.1 0 0]);

    score_Disp = uicontrol('Style','text','Units','normalized','Position',[.125,.2,.75,.125],'String',...
    'Press 9 to exit', 'BackgroundColor',ColorPSscreen,...
    'FontSize',22,'FontWeight','bold','ForegroundColor',[.1 0 0]);

    startButton = uicontrol('Style','pushbutton','Units','normalized','Position',[.4,.1,.2,.1],...
    'String','Continue','FontSize',11);

    c = uicontrol('Style','pushbutton', ...
              'String','Exit', ...
              'Position', [5, 5, 60, 25], ...
              'Callback', @ExitCallback);
    waitforbuttonpress

    %When button pressed end screen
    close(backGround)

    %Increase AFK variable if player loses instantly
    if score == 0
        Easy_Mode=Easy_Mode+1;
    else
        Easy_Mode=0;
    end
end