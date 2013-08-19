function result = foreach(aMap,aHdl,aUseKey,aKeys,aVerbose,aNoResult)
  % takes a matlab map (containers.Map) and a function handle aHdl. 
  % It iterates over the map and calls the function for each item. 
  % if useKey is present and true the current key will be supplied to the
  % function as the second argument. If aKeys (cell array) are given the
  % functions just iterates over the items with these keys
  %
  % Parameters: 
  %      aMap      -  the map on which we do the iteration
  %      aHdl      -  a function handle which is called for each item
  %      aUseKey   -  Optional, default false.
  %                   if true, the function will be called with two
  %                   parameters first the item, then the key
  %      aKeys     -  Optional, default empty. 
  %                   cell array with keys to limit the foreach to a subset
  %                   of items in the map
  %      aVerbose  -  Optional, default false.
  %                   if true foreach outputs which key is called before the
  %                   call is made. 
  %      aNoResult -  Optional, defaults to nargout == 0 
  %                   if true aHdl does not have to return a value, f.ex.
  %                   for aHdl = @disp
  %
  % Example 1: 
  %      myMap = containers.Map();
  %      myMap('one') = 1;
  %      myMap('two') = 2;
  %      myDispFct = @(x,y)fprintf('%s: %i\n',y,x);
  %      foreach(myMap,myDispFct,true);
  %   output:
  %      one: 1
  %      two: 2
  %
  % Example 2 - handy if different datasets need same processing:
  %       timeSig = containers.Map();
  %       legends = containers.Map();
  %       x = 0:0.01:4*pi;
  %       % define two time signals
  %       timeSig('one') = sin(x).*cos(x.^2);
  %       legends('one') = 'Signal 1';
  %       timeSig('two') = sin(2*x.^3).*sin(x);
  %       legends('two') = 'Signal 2';
  %
  %       % now do fft for both datasets
  %       ffts = foreach(timeSig,@fft);
  %
  %       % first plot time signals
  %       doPlot = @(x,y)plot(x,'DisplayName',legends(y));
  %       figure; hold all;
  %       foreach(timeSig, doPlot, true);
  %       legend show;
  %
  %       % then plot fft
  %       doPlot = @(x,y)plot(abs(x),'DisplayName',y);
  %       figure; hold all;
  %       foreach(ffts, doPlot, true);
  %       legend show;
  %
  
  if ~exist('aUseKey','var')
      aUseKey = false;
  end;
  if ~exist('aKeys','var')
      keys = aMap.keys();
  else
      if ~isempty(aKeys)
          keys = aKeys;
      else
          keys = aMap.keys();
      end;
  end;
  if ~exist('aVerbose','var')
      verbose = false;
  else
      verbose = aVerbose;
  end;
  if ~exist('aNoResult','var')
      noresult = nargout == 0;
  else
      noresult = aNoResult;
  end;
  
  result = containers.Map();
  if verbose
      disp(aHdl);
  end;
  for i = 1:numel(keys)
      if verbose
        fprintf('foreach: processing "%s": ',keys{i});
      end;
      if noresult
          if aUseKey
              aHdl(aMap(keys{i}),keys{i});
          else
              aHdl(aMap(keys{i}));
          end;
      else
          if aUseKey
              result(keys{i}) = aHdl(aMap(keys{i}),keys{i});
          else
              result(keys{i}) = aHdl(aMap(keys{i}));
          end;
      end;
      if verbose
        fprintf('OK \n');
      end;
  end;  
end