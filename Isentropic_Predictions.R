# ----------------------
# Purpose:
# Using theta_s (moist isentropic) surfaces appropriate for Antarctic sites,
# evaluate isotope ratio - temperature relationships predicted by moist isentropes
#
# Relevant citations: 
# Casado et al., 2026: Water isotope-temperature relationship variability across Antarctica set by atmospheric circulation. Nature Geoscience
# Bailey, A., H. Singh, and J. Nusbaumer, 2019: Evaluating a moist isentropic framework for poleward moisture transport: Implications for water isotopes over Antarctica. Geophys. Res. Lett., 46, 78109-7827, doi:10.1029/2019GL082965.	
# Marquet, P., and A. Bailey, 2021: Comparisons of H2O pathways with moist isentropes. Research activities in Earth system modeling, Working Group on Numerical Experimentation report 51, WCRP report 4/2021, 162 pp. 
#
# ----------------------

# Load relevant libraries
	library('ncdf4')

# Set lon/lat/elevation (in hPa) of Dumont D'Urville (DDU) and Dome C (DC) in Antarctica
	DDU<- c(140.00000, -66.43979, 944.57852)
	DC<- c(123.75000, -74.92147, 642.87937)

#  Read in temperature, humidity mixing ratio, and latitude, all averaged along seasonally averaged zonal-mean moist isentropic surfaces
# Variables should have dimensions [pressure_level, theta_s_value]
# As per Bailey et al. 2019, average to within +/- 2.5 K using all atmospheric information south of latitude 25 S.
# Theta_s values (K) used in Casado et al. c(310., 300., 292., 285., 277., 265.)

# Set working directory	
	dirpath<-' '
# Set filename 
	fileDJF<-' '
# Open file and extract variables	 for DJF ("control")
	ncid<-nc_open(paste(dirpath,fileDJF,sep=''))	
	Pc<-ncvar_get(ncid,'pressure') # hPa
	Tc<-ncvar_get(ncid, 'temperature')  # K
	MRc<-ncvar_get(ncid,'H2O') # mixing ratio vapor kg/kg
	MR18c<-ncvar_get(ncid,'H218O') # mixing ratio of heavy isotopologue kg/kg normalized by VSMOW
	Lc<-ncvar_get(ncid,'latitude') # 	
	nc_close(ncid)

# Set filename 
	fileJJA<-' '
# Open file and extract variables	 for JJA ("experiment")
	ncid<-nc_open(paste(dirpath,fileJJA,sep=''))	
	Pe<-ncvar_get(ncid,'pressure') # hPa
	Te<-ncvar_get(ncid, 'temperature')  # K
	MRe<-ncvar_get(ncid,'H2O') # mixing ratio vapor kg/kg
	MR18e<-ncvar_get(ncid,'H218O') # mixing ratio of heavy isotopologue kg/kg normalized by VSMOW
	Le<-ncvar_get(ncid,'latitude') # 	
	nc_close(ncid)
	
# Calculate d18O by taking the ratio of mixing ratios
	d18c <- (MR18c/MRc-1) *1000 # permil
	d18e <- (MR18e/MRe-1)*1000 # permil

# Set 1000-hPa level to NA to avoid issues with surface topography
	d18c[21,]<-NA
	
# Calculate d18O-T relationships for DJF/JJA at DDU/DC
# Calclulate spatial slope (DDU v. DC in DJF) by differencing:
	X<-c(Tc[20,5],Tc[14,4]); Y<-c(d18c[20,5], d18c[14,4]); 
	spatial_diff_DJF<-round(diff(Y)/diff(X),2)

# Calculate temporal slope at DDU (JJA - DJF)	by differencing:
	X<-c(Tc[20,5],Te[20,6]); Y<-c(d18c[20,5], d18e[20,6]); 
	temp_diff_DDU<-round(diff(Y)/diff(X),2)

# Calculate temporal slope at DC (JJA - DJF) by differencing:
	X<-c(Tc[14,4],Te[14,5]); Y<-c(d18c[14,4], d18e[14,5]); 
	temp_diff_DC<-round(diff(Y)/diff(X),2)
