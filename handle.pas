unit handle;

interface

    uses CRT;

    type 
        click = (RIGHT_ARROW, LEFT_ARROW, UP_ARROW, DOWN_ARROW, BAD_KEY);
    
    procedure clear_buffer();
    function get_click(): click;
    function buffer_is_empty(): boolean;
    

implementation

procedure clear_buffer();

    begin   
        while KEYPRESSED do 
            readkey(); 
    end;

function get_click(): click;

    var key: char;  
        result: click;

    begin
        result := BAD_KEY;

        key := readkey();
        if (key = #0) then
            begin 
                key := readkey(); 
                case key of 
                    #72: result := UP_ARROW;
                    #80: result := DOWN_ARROW;
                    #77: result := RIGHT_ARROW;
                    #75: result := LEFT_ARROW;
                end;
            end;

        clear_buffer();
        get_click := result;
    end;

function buffer_is_empty(): boolean;

    begin
        buffer_is_empty := not KEYPRESSED; 
    end;

begin 
end.