blas='builtin';
blas_link='-lmwblas -lmwlapack';
DEFBLAS='-DUSE_BLAS_LIB';
if strcmp(blas,'builtin')
    if ~verLessThan('matlab','7.9.0')
        DEFBLAS=[DEFBLAS ' -DNEW_MATLAB_BLAS'];
    else
        DEFBLAS=[DEFBLAS ' -DOLD_MATLAB_BLAS'];
    end
end
links_lib   = blas_link;
link_flags  = '-O';
DEFS = DEFBLAS;
out_dir = 'build';
compile_files = 'mexLassoFast.cpp';
include_directory = 'linalg';

str = [' -I./' include_directory ' ' compile_files ' ' DEFS ' LINKLIBS="$LINKLIBS ' links_lib '" '];

args = regexp(str, '\s+', 'split');
args = args(find(~cellfun(@isempty, args)));

mex(args{:});