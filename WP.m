s=serial('COM9');
fopen(s);
fprintf(s,'/21R0001');
fclose(s);