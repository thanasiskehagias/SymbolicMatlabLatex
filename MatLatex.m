clear all; clc
fn='MatLatexDoc';  	% Put the name (WITHOUT extension) of your symolic/Latex script
SHOW=false;			% true->shows (false->doesn't show) the produced Latex code 

%==========================================================================
% INITIALIZATION
fin=[fn '.m'];
fout=[fn '.tex'];

fid1=fopen(fin,'r');
fid2=fopen(fout,'w');

%==========================================================================
% RUN YOUR SYMBOLIC/LATEX SCRIPT
run([fn '.m'])

%==========================================================================
% GENERATE LATEX

qS=whos;
qj=0;
for qi=1:length(qS)
	if contains(qS(qi).class,'sym')
		qj=qj+1;
		qRepCom(qj).str=['latex(' qS(qi).name ')'];
		qRepCom(qj).str= ['tline=replace(tline,''latex(' qS(qi).name ')'',latex(' qS(qi).name '));'];
	end
	if contains(qS(qi).class,'double') & qS(qi).size==[1 1]
		qj=qj+1;
		qRepCom(qj).str=['num2str(' qS(qi).name ')'];
		qRepCom(qj).str= ['tline=replace(tline,''num2str(' qS(qi).name ')'',num2str(' qS(qi).name '));'];
	end
	%{
	if contains(qS(qi).name,'FIG')
		qj=qj+1;
		qRepCom(qj).str=['figure(' qS(qi).name ')'];
		qRepCom(qj).str= ['tline=replace(tline,''figure(' qS(qi).name ')'',',qS(qi).name ');'];
	end
	%}
end
qRepLen=qj;

str1="";
while ~feof(fid1)
    tline = fgetl(fid1);
    qn=length(tline);
    if qn>1
        aa=tline(1:2);
        if aa=='%%'
            str1=[str1 newline tline(3:qn)];
        end
    end
end
tline=join(str1);
for qj=1:qRepLen
	eval(qRepCom(qj).str);
end
tline=replace(tline,'\','\\');
if SHOW; disp(tline); end
fprintf(fid2,tline);

fclose(fid1);
fclose(fid2);

%==========================================================================
% GENERATE PDF
system(['pdflatex ' fout])
