% Run this file to make the matlab interface for the libgbnp clustering
% algorithms
%
% NOTE: you need to compile the C++ source first using cmake.

%% Change these variables for your setup.

% Default install path
instpath = strcat(strrep(userpath, ':', ''), '/libcluster/');

% Compiler options
eigendir  = '/usr/include/eigen3';
include   = '../include';
clusterdylib = '../lib';
compiler  = 'CXX=g++ CC=g++ LD=g++';

%% Compile... Think twice about changing stuff in here.

% Do not attempt to compile if the Eigen location is wrong.
if ( exist( eigendir, 'dir' ) ~= 7 )
    error( 'MATLAB:libcluster:MakeFile', '\n%s%s%s\n%s', ...
           'The eigen directory: ', eigendir,            ...
           ', does not exist. Cannot compile.',          ...
           'Please specify the correct location of Eign.' );
end

% Get dynamic library name
dlname = dir(strcat(clusterdylib,'/libcluster.*'));
clusterdylib = strcat(clusterdylib,'/',dlname.name);

% Create compile string for cluster
cluster_cmp = sprintf( ...
    'mex %s -I%s -I%s cluster_mex.cpp intfctns.cpp %s', ...
    compiler, eigendir, include, clusterdylib ...
    );

% Create compile string for clustergroup
clustergroup_cmp = sprintf( ...
    'mex %s -I%s -I%s clustergroup_mex.cpp intfctns.cpp %s', ...
    compiler, eigendir, include, clusterdylib ...
    );

% Compile!
fprintf('Compiling cluster...\n')
eval(cluster_cmp);
fprintf('Compiling clustergroup...\n')
eval(clustergroup_cmp);
fprintf('Finished!\n')

%% Install and add to path
ansstr = input('Install files and add to Matlab path? y/n [n]:', 's');

if strcmp(ansstr,'y') || strcmp(ansstr,'Y'),
    instsr = input(sprintf('Where would you like to install the files? [%s]:', instpath),'s');
    if ~isempty(instsr), instpath = instsr; end
    
    if exist(instpath, 'dir') > 0, eval(sprintf('!rm -r %s', instpath)); end
    eval(sprintf('!mkdir %s', instpath));
    
    eval(sprintf('!cp cluster_mex.%s %s', mexext, instpath));
    eval(sprintf('!cp gmmcluster.m %s', instpath));
        
    eval(sprintf('!cp clustergroup_mex.%s %s', mexext, instpath));
    eval(sprintf('!cp gmccluster.m %s', instpath));
    
    eval(sprintf('!cp  SS2GMM.m %s', instpath));
    
    addpath(instpath);
    savepath
end
