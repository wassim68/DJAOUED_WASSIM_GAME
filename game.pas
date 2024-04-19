unit game;

interface

    uses CRT, HANDLE;

    const 
        ROWS = 9;
        COLS = 9;

    type 
        game_item_t = (empty, worm);

        position = record 
            row, col: integer;
        end;

        vector = record 
            on_rows, on_cols: integer;
        end;

        game_config_t = record            
            game_grid: array[0..ROWS, 0..COLS] of game_item_t;
            worm_position: position;
            current_vector: vector;
        end;
    
    procedure run();

implementation

function position_create(row, col: integer): position;

    var result: position;

    begin
        result.row := row;
        result.col := col;
        position_create := result; 
    end;

function vector_create(on_rows, on_cols: integer): vector;

    var result: vector;

    begin
        result.on_rows := on_rows;
        result.on_cols := on_cols;
        vector_create := result; 
    end;


function config_create(): game_config_t;

    var result: game_config_t;
        i, j: integer;

    begin
        result.worm_position := position_create(0, 0);
        for i := 0 to ROWS do
            for j := 0 to COLS do 
                result.game_grid[i, j] := empty;
        result.game_grid[0, 0] := worm;
        result.current_vector := vector_create(0, 1);
        config_create := result;
    end;

function get_new_vector(user_click: click): vector;

    var result: vector;

    begin 
        case user_click of 
            UP_ARROW : result := vector_create(-1, 0);
            DOWN_ARROW: result := vector_create(1, 0);
            LEFT_ARROW: result := vector_create(0, -1);
            RIGHT_ARROW: result := vector_create(0, 1);
        end;

        get_new_vector := result;   
    end;

procedure set_new_vector(var game_config: game_config_t; next_vector: vector);

    begin 
        game_config.current_vector := next_vector;
    end;

function get_row_index(index: integer): integer;

    begin
        if (index < 0) then 
            get_row_index := index + ROWS + 1
        else 
            if (index > ROWS) then 
                get_row_index := index - (ROWS + 1)
            else 
                get_row_index := index;
    end;

function get_col_index(index: integer): integer;

    begin
        if (index < 0) then 
            get_col_index := index + COLS + 1
        else 
            if (index > COLS) then 
                get_col_index := index - (COLS + 1)
            else 
                get_col_index := index;
    end;

procedure set_new_position(var game_config: game_config_t);

    var row, col: integer;

    begin
        game_config.game_grid[game_config.worm_position.row, game_config.worm_position.col] := empty;
        row := game_config.worm_position.row;
        col := game_config.worm_position.col;

        game_config.worm_position.row := get_row_index(row + game_config.current_vector.on_rows);
        game_config.worm_position.col := get_col_index(col + game_config.current_vector.on_cols);

        game_config.game_grid[game_config.worm_position.row, game_config.worm_position.col] := worm;
    end;

procedure render_vector(current_vector: vector);

    var result: string;

    begin
        case current_vector.on_rows of 
            1: result := ' v ';
            -1: result := ' ^ ';
            else 
                case current_vector.on_cols of 
                    1: result := ' > ';
                    -1: result := ' < ';
                end;
        end;
        write(result);
    end;

procedure render_item(game_config: game_config_t; i, j: integer); 

    begin
        case game_config.game_grid[i, j] of 
            empty: write('   ');
            worm: render_vector(game_config.current_vector);
        end;
    end;

procedure render(game_config: game_config_t);

    var i, j: integer;

    begin
        for i := 0 to ROWS + 1 do 
            write('---');
        
        writeln();

        for i := 0 to ROWS do 
            begin 
                write('|');
                for j := 0 to COLS do 
                    render_item(game_config, i, j);       
                writeln('|');
            end; 
        
        
        for i := 0 to ROWS + 1 do 
            write('---');
        
        writeln();
    end;



procedure run();

    var game_config: game_config_t;
        next_vector: vector;
        user_click: click;
        i: integer;
        fps, count: integer;
    
    begin
        fps := 1;
        count := 0;
        game_config := config_create();
        render(game_config);

        repeat
            if (buffer_is_empty()) then 
                set_new_position(game_config) // already put the vector
            else
                begin
                    user_click := get_click();
                    if (user_click = BAD_KEY) then 
                        next_vector := game_config.current_vector
                    else 
                        next_vector := get_new_vector(user_click);
                    set_new_vector(game_config, next_vector);
                    set_new_position(game_config); 
                end;
            delay(100);
            clrscr();
            render(game_config);
        until (FALSE); 
    end;

begin 
end.



