#include <stdio.h>
#include <string.h>
#include <stdlib.h>


int st_mipsVarLength = 100;
int st_mipsValoresLength = 100;
int liInsertado = 0;
int ifnumber = 0;
int whilenumber = 0;
//variables mips
struct MipsVariables {
    char *type;
    char *name;
    int memoryPos;
    int intVal;
    char *stVal;
    double dVal;
    float fval;
};

struct MipsValores {
    int ival;
    float fval;
    double dval;
    int memoryPos;
    char *type;
    char *status;
};

// Declaracion de funciones que se encargan de manejo de ficheros
void clear_file(char *filename);

void write_file(char *filename, char *content);

void write_file_space(char *filename);

// Funciones auxiliares
//Declaraciones
char *integer_to_string(int x);

char *float_to_string(float x);

char *double_to_string(double x);

// instrucciones mips
void mipsIns_create_text(char *filename);

void mipsIns_math_operations_ASG(struct MipsVariables *mipsVariables, char *filename, char operation, char *variable1,
                                 char *variable2, char *variable3);

// variables mips
void mipsVar_create_data(char *filename);

void mipsVar_initialize_struct(struct MipsVariables *mipsVariables);

void mipsVar_initialize_valorStruct(struct MipsValores *mipsValores);

char *mipsVar_get_variable_type(char *type);

void mipsVar_insert_mips_variable_declaration(struct MipsVariables *mipsVariables,
                                              char *type, char *varname, int val1, char *val2, float val3, double val4,
                                              char *filename);

int mipsVar_insert_update_numVar(struct MipsValores *mipsValores, int *li, char *type,
                                 int val1, float val3, double val4);

void mipsVar_write_declarations(struct MipsVariables *mipsVariables, char *filename);

int mipsVar_get_variable_index(char *variable, struct MipsVariables *mipsVariables);

void mipsIns_load_instruction_variable(struct MipsVariables *mipsVariables, char *filename, int index);

void mipsIns_if_var_var(struct MipsVariables *mipsVariables, char *filename, char *operation, char *variable1,
                        char *variable2);

void mipsIns_endIf(char *filename);

void mipsIns_else(char *filename);

void mipsIns_numOperation(struct MipsValores *mipsValores, int *li, char *filename, char operation,
                          int intvar1, int intvar2, float fvar1, float fvar2, double dvar1, double dvar2);

char *mipsVar_assign_memory_pos(int i);

char *mipsIns_createLi_variable(int li);

void mipsIns_write_li_instruction(char *filename, char *memory_pos, char *value);

void mipsIns_if_var_num(struct MipsVariables *mipsVariables, struct MipsValores *mipsValores, char *filename,
                        char *operation, char *variable1, char *type, int num1, float num2);

void mipsIns_asign_var_to_var(char *filename, struct MipsVariables *mipsVariables, char *varname, char *varname2);

void mipsIns_asign_val_to_var(char *filename, struct MipsVariables *mipsVariables, struct MipsValores *mipsValores,
                              char *varname, char *type, int val1, float val2);

void mipsIns_if_num_num(struct MipsValores *mipsValores, char *filename, char *operation,
                        char *type, int num1, float num2, char *type2, int num3, float num4);

void mipsIns_while_var_var(struct MipsVariables *mipsVariables, char *filename, char *varname, char *varname2,
                           char *operation);

void mipsIns_while_var_num(struct MipsVariables *mipsVariables, struct MipsValores *mipsValores, char *filename,
                           char *varname, char *type, int value, float value2, char *operation);

void mipsIns_while_num_num(struct MipsValores *mipsValores, char *filename, char *type,
                           int value, float value2, char *type2, int value3, float value4, char *operation);

void mipsIns_simpleOperations(struct MipsVariables *mipsVariables, char *filename, char operation, char *variable1,
                              char *type, int val1, float val2);


void clear_file(char *filename) {
    FILE *file;
    file = fopen(filename, "w");
}

void write_file(char *filename, char *content) {
    FILE *file;
    file = fopen(filename, "a");
    fprintf(file, "%s", content);
    fclose(file);
}

void write_file_space(char *filename) {
    FILE *file;
    file = fopen(filename, "a");
    fprintf(file, "%s", " ");
    fclose(file);
}

// Funciones auxiliares
// Cosas de utilidad que he necesitado montarme porque C es para gente que esta zumbada
char *integer_to_string(int x) {
    char *buffer = malloc(sizeof(char) * sizeof(int) * 4 + 1);
    if (buffer) {
        sprintf(buffer, "%d", x);
    }
    return buffer;
}

char *float_to_string(float x) {
    char *buffer = malloc(sizeof(char) * sizeof(float) * 16 + 1);
    if (buffer) {
        sprintf(buffer, "%f", x);
    }
    return buffer;
}

char *double_to_string(double x) {
    char *buffer = malloc(sizeof(char) * sizeof(int) * 8 + 1);
    if (buffer) {
        sprintf(buffer, "%f", x);
    }
    return buffer;
}

// instrucciones mips
void mipsIns_create_text(char *filename) {
    write_file(filename, ".text");
    write_file(filename, "\n");
}


// variables mips
void mipsVar_create_data(char *filename) {
    write_file(filename, ".data\n");
}

void mipsVar_initialize_struct(struct MipsVariables *mipsVariables) {
    for (int i = 0; i < st_mipsVarLength; i++) {
        mipsVariables[i].name = "._empty";
        mipsVariables[i].type = "._empty";
        mipsVariables[i].memoryPos = 0;
        mipsVariables[i].intVal = -500;
        mipsVariables[i].stVal = NULL;
        mipsVariables[i].dVal = -500;
        mipsVariables[i].fval = -500;
    }
}

void mipsVar_initialize_valorStruct(struct MipsValores *mipsValores) {
    for (int i = 0; i < st_mipsVarLength; i++) {
        mipsValores[i].memoryPos = 0;
        mipsValores[i].fval = -500;
        mipsValores[i].ival = -500;
        mipsValores[i].dval = -500;
        mipsValores[i].status = NULL;
    }
}

char *mipsVar_assign_memory_pos(int i) {
    char *start = "$s";
    char *position = integer_to_string(i);
    char tmp[5000];
    strcpy(tmp, start);
    strcat(tmp, position);
    char *final = tmp;
    return final;
}

char *mipsVar_get_variable_type(char *type) {
    if (strcmp(type, "integer") == 0) {
        return ".word";
    } else if (strcmp(type, "float") == 0) {
        return ".float";
    } else if (strcmp(type, "char") == 0) {
        return "ascii";
    } else if (strcmp(type, "boolean") == 0) {
        return ".word";
    } else if (strcmp(type, "double") == 0) {
        return ".double";
    } else if (strcmp(type, "string") == 0) {
        return ".ascii";
    } else {
        return "yes";
    }
}


void mipsVar_insert_mips_variable_declaration(struct MipsVariables *mipsVariables,
                                              char *type, char *varname, int val1,
                                              char *val2, float val3, double val4, char *filename) {
    int i = 0;
    int encontrado = 0;
    while (i < st_mipsVarLength && encontrado == 0) {
        if (strcmp(mipsVariables[i].name, "._empty") == 0) {
            mipsVariables[i].name = varname;
            mipsVariables[i].type = type;
            mipsVariables[i].memoryPos = i;
            mipsVariables[i].intVal = val1;
            mipsVariables[i].stVal = val2;
            mipsVariables[i].fval = val3;
            mipsVariables[i].dVal = val4;
            mipsIns_load_instruction_variable(mipsVariables, filename, i);
            encontrado = 1;
        } else {
            i += 1;
        }
    }
}


void mipsVar_write_declarations(struct MipsVariables *mipsVariables, char *filename) {
    int i = 0;
    int fin = 0;
    while (i < st_mipsVarLength && fin == 0) {
        if (strcmp(mipsVariables[i].name, "._empty") == 0) {
            fin = 1;
        } else {
            char *varname = mipsVariables[i].name;
            char *type = mipsVariables[i].type;
            char *mips_type = mipsVar_get_variable_type(type);
            write_file(filename, varname);
            write_file(filename, ":");
            write_file_space(filename);
            write_file(filename, mips_type);

            write_file_space(filename);
            if (strcmp(type, "integer") == 0) {
                if (mipsVariables[i].intVal != -500) {
                    write_file(filename, integer_to_string(mipsVariables[i].intVal));
                }
            } else if (strcmp(type, "float") == 0) {
                if (mipsVariables[i].fval != -500) {
                    write_file(filename, float_to_string(mipsVariables[i].fval));
                }
            } else if (strcmp(type, "double") == 0) {
                if (mipsVariables[i].dVal != -500) {
                    write_file(filename, double_to_string(mipsVariables[i].dVal));
                }
            } else if (strcmp(type, "string") == 0) {
                if (mipsVariables[i].stVal != NULL) {
                    write_file(filename, "\"");
                    write_file(filename, mipsVariables[i].stVal);
                    write_file(filename, "\"");
                }
            }
            write_file(filename, "\n");
            i += 1;
        }
    }
}

// a = b + c
void mipsIns_math_operations_ASG(struct MipsVariables *mipsVariables, char *filename, char operation, char *variable1,
                                 char *variable2, char *variable3) {
    int index_1 = mipsVar_get_variable_index(variable1, mipsVariables);
    int index_2 = mipsVar_get_variable_index(variable2, mipsVariables);
    int index_3 = mipsVar_get_variable_index(variable3, mipsVariables);
    if (index_1 != -500 && index_2 != -500) {
        if (strcmp(mipsVariables[index_1].type, mipsVariables[index_2].type) == 0 &&
            strcmp(mipsVariables[index_1].type, mipsVariables[index_3].type) == 0 &&
            strcmp(mipsVariables[index_2].type, mipsVariables[index_3].type) == 0) {
            if (operation == '+') {
                write_file(filename, "add ");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
                write_file(filename, ",");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
                write_file(filename, ",");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_3].memoryPos));
                write_file(filename, "\n");
            } else if (operation == '-') {
                write_file(filename, "sub ");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_3].memoryPos));
                write_file(filename, ",");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
                write_file(filename, ",");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
                write_file(filename, "\n");
            } else if (operation == '*') {
                write_file(filename, "mul ");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_3].memoryPos));
                write_file(filename, ",");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
                write_file(filename, ",");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
                write_file(filename, "\n");
            } else if (operation == '/') {
                write_file(filename, "div ");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_3].memoryPos));
                write_file(filename, ",");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
                write_file(filename, ",");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
                write_file(filename, "\n");
            }
        }
    }
}

// a = a + 1
void mipsIns_simpleOperations(struct MipsVariables *mipsVariables, char *filename, char operation, char *variable1,
                              char *type, int val1, float val2) {
    int index_1 = mipsVar_get_variable_index(variable1, mipsVariables);
    if (index_1 != -500) {
        if (strcmp(type, mipsVariables[index_1].type) == 0) {
            if (operation == '+') {
                write_file(filename, "add ");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
                write_file(filename, ",");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
                write_file(filename, ",");
                if (strcmp(type, "integer") == 0) {
                    write_file(filename, integer_to_string(val1));
                } else if (strcmp(type, "float") == 0) {
                    write_file(filename, float_to_string(val2));
                }                

                write_file(filename, "\n");
            } else if (operation == '-') {
                write_file(filename, "sub ");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
                write_file(filename, ",");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
                write_file(filename, ",");
                if (strcmp(type, "integer") == 0) {
                    write_file(filename, integer_to_string(val1));
                } else if (strcmp(type, "float") == 0) {
                    write_file(filename, float_to_string(val2));
                }
                write_file(filename, "\n");
            } else if (operation == '*') {
                write_file(filename, "mul ");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
                write_file(filename, ",");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));     
                write_file(filename, ",");                           
                if (strcmp(type, "integer") == 0) {
                    write_file(filename, integer_to_string(val1));
                } else if (strcmp(type, "float") == 0) {
                    write_file(filename, float_to_string(val2));
                }
                write_file(filename, "\n");
            } else if (operation == '/') {
                write_file(filename, "div ");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
                write_file(filename, ",");
                write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));     
                write_file(filename, ",");                           
                if (strcmp(type, "integer") == 0) {
                    write_file(filename, integer_to_string(val1));
                } else if (strcmp(type, "float") == 0) {
                    write_file(filename, float_to_string(val2));
                }
                write_file(filename, "\n");
            }
        }

    }
}


int mipsVar_get_variable_index(char *variable, struct MipsVariables *mipsVariables) {
    int i = 0;
    int index = 0;
    int encontrado = 0;
    while (i < st_mipsVarLength && encontrado == 0) {
        if (strcmp(mipsVariables[i].name, variable) == 0) {
            encontrado = 1;
            index = i;
        } else {
            i++;
        }
    }
    if (encontrado == 0) {
        return -500;
    } else {
        return index;
    }
}

void mipsIns_load_instruction_variable(struct MipsVariables *mipsVariables, char *filename, int index) {
    write_file(filename, "lw ");
    write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index].memoryPos));
    write_file(filename, ",");
    write_file(filename, mipsVariables[index].name);
    write_file(filename, "\n");
}

void mipsIns_if_var_var(struct MipsVariables *mipsVariables, char *filename,
                        char *operation, char *variable1, char *variable2) {
    int index_1 = mipsVar_get_variable_index(variable1, mipsVariables);
    int index_2 = mipsVar_get_variable_index(variable2, mipsVariables);
    if (strcmp(operation, "=") == 0) {
        write_file(filename, "beq ");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
        write_file(filename, ",");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
        write_file(filename, ",");
        write_file(filename, " then");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, "\n j endif");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, "\n then");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, ":\n");

    } else if (strcmp(operation, "!=") == 0) {
        write_file(filename, "bne ");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
        write_file(filename, ",");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
        write_file(filename, ",");
        write_file(filename, " then");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, "\n j endif");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, "\n then");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, ":\n");
    } else if (strcmp(operation, ">") == 0) {
        write_file(filename, "bgt ");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
        write_file(filename, ",");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
        write_file(filename, ",");
        write_file(filename, " then");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, "\n j endif");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, "\n then");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, ":\n");
    } else if (strcmp(operation, ">=") == 0) {
        write_file(filename, "bge ");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
        write_file(filename, ",");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
        write_file(filename, ",");
        write_file(filename, " then");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, "\n j endif");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, "\n then");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, ":\n");
    } else if (strcmp(operation, "<") == 0) {
        write_file(filename, "blt ");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
        write_file(filename, ",");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
        write_file(filename, ",");
        write_file(filename, " then");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, "\n j endif");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, "\n then");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, ":\n");
    } else if (strcmp(operation, "<=") == 0) {
        write_file(filename, "ble ");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
        write_file(filename, ",");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
        write_file(filename, ",");
        write_file(filename, " then");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, "\n j endif");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, "\n then");
        write_file(filename, integer_to_string(ifnumber));
        write_file(filename, ":\n");
    }
}

void mipsIns_if_var_num(struct MipsVariables *mipsVariables, struct MipsValores *mipsValores, char *filename,
                        char *operation, char *variable1, char *type, int num1, float num2) {

    int index_1 = mipsVar_get_variable_index(variable1, mipsVariables);
    if (strcmp(mipsVariables[index_1].type, type) == 0) {
        int index_2 = 0;
        if (strcmp(type, "integer") == 0) {
            index_2 = mipsVar_insert_update_numVar(mipsValores, 0, type, num1, 0, 0);
        } else if (strcmp(type, "float") == 0) {
            index_2 = mipsVar_insert_update_numVar(mipsValores, 0, type, 0, num2, 0);
        }
        if (strcmp(operation, "=") == 0) {
            if (strcmp(type, "integer") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             integer_to_string(mipsValores[index_2].ival));
            } else if (strcmp(type, "float") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             float_to_string(mipsValores[index_2].fval));
            }
            write_file(filename, "beq ");
            write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, ",");
            write_file(filename, " then");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, "\n j endif");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, "\n then");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, ":\n");          

        } else if (strcmp(operation, "!=") == 0) {//bne
            if (strcmp(type, "integer") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             integer_to_string(mipsValores[index_2].ival));
            } else if (strcmp(type, "float") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             float_to_string(mipsValores[index_2].fval));
            }
            write_file(filename, "bne ");
            write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, ",");
            write_file(filename, " then");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, "\n j endif");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, "\n then");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, ":\n");

        } else if (strcmp(operation, ">") == 0) {//bgt
            if (strcmp(type, "integer") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             integer_to_string(mipsValores[index_2].ival));
            } else if (strcmp(type, "float") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             float_to_string(mipsValores[index_2].fval));
            }
            write_file(filename, "bgt ");
            write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, ",");
            write_file(filename, " then");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, "\n j endif");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, "\n then");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, ":\n");
        } else if (strcmp(operation, ">=") == 0) {//bge
            if (strcmp(type, "integer") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             integer_to_string(mipsValores[index_2].ival));
            } else if (strcmp(type, "float") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             float_to_string(mipsValores[index_2].fval));
            }
            write_file(filename, "bge ");
            write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, ",");
            write_file(filename, " then");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, "\n j endif");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, "\n then");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, ":\n");
        } else if (strcmp(operation, "<") == 0) {//blt
            if (strcmp(type, "integer") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             integer_to_string(mipsValores[index_2].ival));
            } else if (strcmp(type, "float") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             float_to_string(mipsValores[index_2].fval));
            }
            write_file(filename, "blt ");
            write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, ",");
            write_file(filename, " then");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, "\n j endif");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, "\n then");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, ":\n");
        } else if (strcmp(operation, "<=") == 0) {//ble
            if (strcmp(type, "integer") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             integer_to_string(mipsValores[index_2].ival));
            } else if (strcmp(type, "float") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             float_to_string(mipsValores[index_2].fval));
            }
            write_file(filename, "ble ");
            write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, ",");
            write_file(filename, " then");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, "\n j endif");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, "\n then");
            write_file(filename, integer_to_string(ifnumber));
            write_file(filename, ":\n");           
        }
    }
}

void mipsIns_if_num_num(struct MipsValores *mipsValores, char *filename, char *operation,
                        char *type, int num1, float num2, char *type2, int num3, float num4) {

    if (strcmp(type, type2) == 0) {
        int index_1 = 0;
        int index_2 = 0;
        if (strcmp(type, "integer") == 0) {
            index_1 = mipsVar_insert_update_numVar(mipsValores, 0, type, num1, 0, 0);
            index_2 = mipsVar_insert_update_numVar(mipsValores, 0, type, num3, 0, 0);
        } else if (strcmp(type, "float") == 0) {
            index_1 = mipsVar_insert_update_numVar(mipsValores, 0, type, 0, num2, 0);
            index_2 = mipsVar_insert_update_numVar(mipsValores, 0, type, 0, num4, 0);
        }
        if (strcmp(operation, "=") == 0) {
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                         integer_to_string(mipsValores[index_2].ival));
            write_file(filename, "beq ");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, " then\n");

        } else if (strcmp(operation, "!=") == 0) {//bne
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                         integer_to_string(mipsValores[index_2].ival));
            write_file(filename, "bne ");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, " then\n");

        } else if (strcmp(operation, ">") == 0) {//bgt
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                         integer_to_string(mipsValores[index_2].ival));
            write_file(filename, "bgt ");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, " then\n");

        } else if (strcmp(operation, ">=") == 0) {//bge
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                         integer_to_string(mipsValores[index_2].ival));
            write_file(filename, "bge ");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, " then\n");

        } else if (strcmp(operation, "<") == 0) {//blt
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                         integer_to_string(mipsValores[index_2].ival));
            write_file(filename, "blt ");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, " then\n");

        } else if (strcmp(operation, "<=") == 0) {//ble
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                         integer_to_string(mipsValores[index_2].ival));
            write_file(filename, "ble ");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, " then\n");
        }
    }
}

void mipsIns_endIf(char *filename) {
    write_file(filename, "\n");
    write_file(filename, "endif");
    write_file(filename, integer_to_string(ifnumber));
    write_file(filename, ":");
    write_file(filename, "\n");    
    write_file(filename, "\n");  
    ifnumber+=1;
}

void mipsIns_endWhile(char *filename) {
    write_file(filename, "\n");    
    write_file(filename, "j Loop");
    write_file(filename, integer_to_string(whilenumber));
    write_file(filename, "\n");    
    write_file(filename, " exit");
    write_file(filename, integer_to_string(whilenumber));
    write_file(filename, ":\n");

    whilenumber += 1;
}

void mipsIns_else(char *filename) {
    write_file(filename, "ELSE: \n");
}

// esto es para hacer 1+1
void mipsIns_numOperation(struct MipsValores *mipsValores, int *li, char *filename, char operation,
                          int intvar1, int intvar2, float fvar1, float fvar2, double dvar1,
                          double dvar2) {
    if (intvar1 != -500 && intvar2 != -500) {
        if (operation == '+') {
            int index1 = mipsVar_insert_update_numVar(mipsValores, li, "integer", intvar1, 0, 0);
            int index2 = mipsVar_insert_update_numVar(mipsValores, li, "integer", intvar2, 0, 0);
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos),
                                         integer_to_string(mipsValores[index1].ival));
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos),
                                         integer_to_string(mipsValores[index2].ival));
            mipsIns_write_li_instruction(filename, "$a0", integer_to_string(0));

            write_file(filename, "add ");
            write_file(filename, "$a0");
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos));
            write_file(filename, "\n");

        } else if (operation == '-') {
            int index1 = mipsVar_insert_update_numVar(mipsValores, li, "integer", intvar1, 0, 0);
            int index2 = mipsVar_insert_update_numVar(mipsValores, li, "integer", intvar2, 0, 0);
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos),
                                         integer_to_string(mipsValores[index1].ival));
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos),
                                         integer_to_string(mipsValores[index2].ival));
            mipsIns_write_li_instruction(filename, "$a0", integer_to_string(0));

            write_file(filename, "sub ");
            write_file(filename, "$a0");
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos));
            write_file(filename, "\n");
        } else if (operation == '*') {
            int index1 = mipsVar_insert_update_numVar(mipsValores, li, "integer", intvar1, 0, 0);
            int index2 = mipsVar_insert_update_numVar(mipsValores, li, "integer", intvar2, 0, 0);
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos),
                                         integer_to_string(mipsValores[index1].ival));

            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos),
                                         integer_to_string(mipsValores[index2].ival));
            mipsIns_write_li_instruction(filename, "$a0", integer_to_string(0));

            write_file(filename, "mul ");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos));
            write_file(filename, "\n");
        } else if (operation == '/') {
            int index1 = mipsVar_insert_update_numVar(mipsValores, li, "integer", intvar1, 0, 0);
            int index2 = mipsVar_insert_update_numVar(mipsValores, li, "integer", intvar2, 0, 0);
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos),
                                         integer_to_string(mipsValores[index1].ival));

            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos),
                                         integer_to_string(mipsValores[index2].ival));
            mipsIns_write_li_instruction(filename, "$a0", integer_to_string(0));

            write_file(filename, "div ");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos));
            write_file(filename, "\n");
        }
    } else if (fvar1 != -500 && fvar2 != -500) {
        if (operation == '+') {
            int index1 = mipsVar_insert_update_numVar(mipsValores, li, "float", 0, fvar1, 0);
            int index2 = mipsVar_insert_update_numVar(mipsValores, li, "float", 0, fvar2, 0);
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos),
                                         float_to_string(mipsValores[index1].fval));

            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos),
                                         float_to_string(mipsValores[index2].fval));
            mipsIns_write_li_instruction(filename, "$a0", integer_to_string(0));

            write_file(filename, "add ");
            write_file(filename, "$a0");
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos));
            write_file(filename, "\n");
        } else if (operation == '-') {
            int index1 = mipsVar_insert_update_numVar(mipsValores, li, "float", 0, fvar1, 0);
            int index2 = mipsVar_insert_update_numVar(mipsValores, li, "float", 0, fvar2, 0);
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos),
                                         float_to_string(mipsValores[index1].fval));

            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos),
                                         float_to_string(mipsValores[index2].fval));
            mipsIns_write_li_instruction(filename, "$a0", integer_to_string(0));

            write_file(filename, "sub ");
            write_file(filename, "$a0");
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos));
            write_file(filename, "\n");
        } else if (operation == '*') {
            int index1 = mipsVar_insert_update_numVar(mipsValores, li, "float", 0, fvar1, 0);
            int index2 = mipsVar_insert_update_numVar(mipsValores, li, "float", 0, fvar2, 0);
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos),
                                         float_to_string(mipsValores[index1].fval));

            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos),
                                         float_to_string(mipsValores[index2].fval));
            mipsIns_write_li_instruction(filename, "$a0", integer_to_string(0));

            write_file(filename, "mul ");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos));
            write_file(filename, "\n");
        } else if (operation == '/') {
            int index1 = mipsVar_insert_update_numVar(mipsValores, li, "float", 0, fvar1, 0);
            int index2 = mipsVar_insert_update_numVar(mipsValores, li, "float", 0, fvar2, 0);
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos),
                                         float_to_string(mipsValores[index1].fval));

            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos),
                                         float_to_string(mipsValores[index2].fval));
            mipsIns_write_li_instruction(filename, "$a0", integer_to_string(0));

            write_file(filename, "div ");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos));
            write_file(filename, "\n");
        }
    } else if (dvar1 != -500 && dvar2 != -500) {
        if (operation == '+') {
            int index1 = mipsVar_insert_update_numVar(mipsValores, li, "double", 0, 0, dvar1);
            int index2 = mipsVar_insert_update_numVar(mipsValores, li, "double", 0, 0, dvar2);
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos),
                                         integer_to_string(mipsValores[index1].ival));

            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos),
                                         integer_to_string(mipsValores[index2].ival));
            mipsIns_write_li_instruction(filename, "$a0", integer_to_string(0));

            write_file(filename, "add ");
            write_file(filename, "$a0");
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos));
            write_file(filename, "\n");
        } else if (operation == '-') {
            int index1 = mipsVar_insert_update_numVar(mipsValores, li, "double", 0, 0, dvar1);
            int index2 = mipsVar_insert_update_numVar(mipsValores, li, "double", 0, 0, dvar2);
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos),
                                         integer_to_string(mipsValores[index1].ival));

            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos),
                                         integer_to_string(mipsValores[index2].ival));
            mipsIns_write_li_instruction(filename, "$a0", integer_to_string(0));

            write_file(filename, "sub ");
            write_file(filename, "$a0");
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos));
            write_file(filename, "\n");
        } else if (operation == '*') {
            int index1 = mipsVar_insert_update_numVar(mipsValores, li, "double", 0, 0, dvar1);
            int index2 = mipsVar_insert_update_numVar(mipsValores, li, "double", 0, 0, dvar2);
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos),
                                         integer_to_string(mipsValores[index1].ival));

            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos),
                                         integer_to_string(mipsValores[index2].ival));
            mipsIns_write_li_instruction(filename, "$a0", integer_to_string(0));

            write_file(filename, "mul ");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos));
            write_file(filename, "\n");
        } else if (operation == '/') {
            int index1 = mipsVar_insert_update_numVar(mipsValores, li, "double", 0, 0, dvar1);
            int index2 = mipsVar_insert_update_numVar(mipsValores, li, "double", 0, 0, dvar2);
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos),
                                         integer_to_string(mipsValores[index1].ival));

            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos),
                                         integer_to_string(mipsValores[index2].ival));
            mipsIns_write_li_instruction(filename, "$a0", integer_to_string(0));

            write_file(filename, "div ");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index2].memoryPos));
            write_file(filename, "\n");
        }

    }

}

int mipsVar_insert_update_numVar(struct MipsValores *mipsValores, int *li,
                                 char *type, int val1, float val3, double val4) {
    int i = 0;
    int encontrado = 0;
    while (i < st_mipsValoresLength && encontrado == 0) {
        if (mipsValores[i].status == NULL) {

            mipsValores[i].status = "ocupado";
            mipsValores[i].ival = val1;
            mipsValores[i].dval = val4;
            mipsValores[i].fval = val3;
            mipsValores[i].type = type;
            mipsValores[i].memoryPos = i;
            encontrado = 1;
            liInsertado += 1;
        } else {
            i += 1;
        }
    }
    return i;
}


char *mipsIns_createLi_variable(int li) {
    char *start = "$t";
    char *position = integer_to_string(li);
    char tmp[5000];
    strcpy(tmp, start);
    strcat(tmp, position);
    char *final = tmp;

    return final;
}

void mipsIns_write_li_instruction(char *filename, char *memory_pos, char *value) {
    write_file(filename, "li ");
    write_file(filename, memory_pos);
    write_file(filename, ", ");
    write_file(filename, value);
    write_file(filename, "\n");

}

void mipsIns_asign_var_to_var(char *filename, struct MipsVariables *mipsVariables, char *varname, char *varname2) {
    int index_1 = mipsVar_get_variable_index(varname, mipsVariables);
    int index_2 = mipsVar_get_variable_index(varname2, mipsVariables);
    if (strcmp(mipsVariables[index_1].type, mipsVariables[index_2].type) == 0) {
        int index_2 = 0;
        write_file(filename, "move ");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
        write_file(filename, ", ");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
        write_file(filename, "\n");
    }
}

void mipsIns_asign_val_to_var(char *filename, struct MipsVariables *mipsVariables, struct MipsValores *mipsValores,
                              char *varname, char *type, int val1, float val2) {
    int index_1 = mipsVar_get_variable_index(varname, mipsVariables);
    if (strcmp(mipsVariables[index_1].type, type) == 0) {
        int index_2 = 0;
        if (strcmp(type, "integer") == 0) {
            index_2 = mipsVar_insert_update_numVar(mipsValores, 0, type, val1, 0, 0);
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                         integer_to_string(mipsValores[index_2].ival));
        } else if (strcmp(type, "float") == 0) {
            index_2 = mipsVar_insert_update_numVar(mipsValores, 0, type, 0, val2, 0);
            mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                         float_to_string(mipsValores[index_2].fval));
        }
        write_file(filename, "move ");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
        write_file(filename, ", ");
        write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
        write_file(filename, "\n");

    }
}

void mipsIns_while_var_var(struct MipsVariables *mipsVariables, char *filename, char *varname, char *varname2,
                           char *operation) {
    int index_1 = mipsVar_get_variable_index(varname, mipsVariables);
    int index_2 = mipsVar_get_variable_index(varname2, mipsVariables);
    write_file(filename, "Loop");
    write_file(filename, integer_to_string(whilenumber));
    write_file(filename, ":\n");
    if (strcmp(operation, "=") == 0) {
        write_file(filename, "beq ");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
        write_file(filename, ",");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
        write_file(filename, ",");
        write_file(filename, " exit");
        write_file(filename, integer_to_string(whilenumber));
        write_file(filename, "\n");

    } else if (strcmp(operation, "!=") == 0) {
        write_file(filename, "bne ");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
        write_file(filename, ",");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
        write_file(filename, " exit");
        write_file(filename, integer_to_string(whilenumber));
        write_file(filename, "\n");            

    } else if (strcmp(operation, ">") == 0) {
        write_file(filename, "blt ");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
        write_file(filename, ",");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
        write_file(filename, " exit");
        write_file(filename, integer_to_string(whilenumber));
        write_file(filename, "\n"); 

    } else if (strcmp(operation, ">=") == 0) {
        write_file(filename, "ble ");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
        write_file(filename, ",");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
        write_file(filename, " exit");
        write_file(filename, integer_to_string(whilenumber));
        write_file(filename, "\n"); 

    } else if (strcmp(operation, "<") == 0) {
        write_file(filename, "bgt ");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
        write_file(filename, ",");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
        write_file(filename, " exit");
        write_file(filename, integer_to_string(whilenumber));
        write_file(filename, "\n"); 


    } else if (strcmp(operation, "<=") == 0) {
        write_file(filename, "bge ");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
        write_file(filename, ",");
        write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_2].memoryPos));
        write_file(filename, " exit");
        write_file(filename, integer_to_string(whilenumber));
        write_file(filename, "\n"); 
    }
}

void mipsIns_while_var_num(struct MipsVariables *mipsVariables, struct MipsValores *mipsValores, char *filename,
                           char *varname, char *type, int value, float value2, char *operation) {
    int index_1 = mipsVar_get_variable_index(varname, mipsVariables);
    if (strcmp(mipsVariables[index_1].type, type) == 0) {
        int index_2 = 0;
        if (strcmp(type, "integer") == 0) {
            index_2 = mipsVar_insert_update_numVar(mipsValores, 0, type, value, 0, 0);
        } else if (strcmp(type, "float") == 0) {
            index_2 = mipsVar_insert_update_numVar(mipsValores, 0, type, 0, value2, 0);
        }
        if (strcmp(operation, "=") == 0) {
            if (strcmp(type, "integer") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             integer_to_string(mipsValores[index_2].ival));
            } else if (strcmp(type, "float") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             float_to_string(mipsValores[index_2].fval));
            }
            write_file(filename, "Loop");
            write_file(filename, integer_to_string(whilenumber));
            write_file(filename, ": ");
            write_file(filename, "beq ");
            write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, " exit");
            write_file(filename, integer_to_string(whilenumber));
            write_file(filename, "\n");

        } else if (strcmp(operation, "!=") == 0) {//bne
            if (strcmp(type, "integer") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             integer_to_string(mipsValores[index_2].ival));
            } else if (strcmp(type, "float") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             float_to_string(mipsValores[index_2].fval));
            }
            write_file(filename, "Loop");
            write_file(filename, integer_to_string(whilenumber));
            write_file(filename, ": ");
            write_file(filename, "bne ");
            write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, " exit");
            write_file(filename, integer_to_string(whilenumber));
            write_file(filename, "\n");

        } else if (strcmp(operation, ">") == 0) {//bgt
            if (strcmp(type, "integer") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             integer_to_string(mipsValores[index_2].ival));
            } else if (strcmp(type, "float") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             float_to_string(mipsValores[index_2].fval));
            }
            write_file(filename, "Loop");
            write_file(filename, integer_to_string(whilenumber));
            write_file(filename, ": ");
            write_file(filename, "blt ");
            write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, " exit");
            write_file(filename, integer_to_string(whilenumber));
            write_file(filename, "\n");

        } else if (strcmp(operation, ">=") == 0) {//bge
            if (strcmp(type, "integer") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             integer_to_string(mipsValores[index_2].ival));
            } else if (strcmp(type, "float") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             float_to_string(mipsValores[index_2].fval));
            }
            write_file(filename, "Loop");
            write_file(filename, integer_to_string(whilenumber));
            write_file(filename, ": ");
            write_file(filename, "ble ");
            write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, " exit");
            write_file(filename, integer_to_string(whilenumber));
            write_file(filename, "\n");
        } else if (strcmp(operation, "<") == 0) {//blt
            if (strcmp(type, "integer") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             integer_to_string(mipsValores[index_2].ival));
            } else if (strcmp(type, "float") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             float_to_string(mipsValores[index_2].fval));
            }
            write_file(filename, "Loop");
            write_file(filename, integer_to_string(whilenumber));
            write_file(filename, ": ");
            write_file(filename, "bgt ");
            write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, " exit");
            write_file(filename, integer_to_string(whilenumber));
            write_file(filename, "\n");

        } else if (strcmp(operation, "<=") == 0) {//ble
            if (strcmp(type, "integer") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             integer_to_string(mipsValores[index_2].ival));
            } else if (strcmp(type, "float") == 0) {
                mipsIns_write_li_instruction(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos),
                                             float_to_string(mipsValores[index_2].fval));
            }
            write_file(filename, "Loop");
            write_file(filename, integer_to_string(whilenumber));
            write_file(filename, ": ");
            write_file(filename, "bge ");
            write_file(filename, mipsVar_assign_memory_pos(mipsVariables[index_1].memoryPos));
            write_file(filename, ",");
            write_file(filename, mipsIns_createLi_variable(mipsValores[index_2].memoryPos));
            write_file(filename, " exit");
            write_file(filename, integer_to_string(whilenumber));
            write_file(filename, "\n");
        }
    }

}

void mipsIns_while_num_num(struct MipsValores *mipsValores, char *filename, char *type,
                           int value, float value2, char *type2, int value3, float value4, char *operation) {

    if (strcmp(type, type2) == 0) {
        write_file(filename, "Loop:\n");
        mipsIns_if_num_num(mipsValores, filename, operation, type, value, value2, type2, value3, value4);
    }

}
