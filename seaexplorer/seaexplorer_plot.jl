#include("seaexplorer_load_rt.jl")
import seaexplorer_functions: cleanEPS, cleanTemp, cleanSalt

using Plots, NaNMath, Dates
plotly()

figoutdir = "/Users/gong/Research/sea064/figures/"

if mission == 38 # LBE
    region = "LBE"
    lims_temp = (-0.2, 8.0);
    lims_salt = (35.05, 35.4);
    lims_sigma0 = (27.2, 28.12);
    lims_spice0 = (-0.05, 1.05);
    lims_uv = (-0.6, 0.6);
    lims_sndspd = (1462, 1485);
    t1 = Dates.DateTime(2022,11,02,12,0,0);
    t2 = Dates.DateTime(2022,11,30,12,0,0);
elseif mission == 37 # Jan Mayen
    region = "JM"
    lims_temp = (-0.5, 6.0);
    lims_salt = (34.6, 35.2);
    lims_sigma0 = (27.4, 28.1);
    lims_spice0 = (-0.1, 0.55);
    lims_uv = (-0.4, 0.4);
    lims_sndspd = (1450, 1475);
    t1 = Dates.DateTime(2022,10,21,12,0,0);
    t2 = Dates.DateTime(2022,10,31,12,0,0);
end

tind = findall(t1 .<= sea064pld1d.t .<= t2);
tindmid = findall((t1 .<= tmid .<= t2) .&& (zmid .<= -2.0));

l8out8 = @layout([a; b; c; d; e; f; g; h])
l8out7 = @layout([a; b; c; d; e; f; g])
l8out6 = @layout([a; b; c; d; e; f])
l8out5 = @layout([a; b; c; d; e])
l8out4 = @layout([a; b; c; d])
l8out3 = @layout([a; b; c])

ms = 2;

saltAi = lims_salt[1]-0.5 : 0.005 : lims_salt[end]+0.5;
ctempi = lims_temp[1]-1 : 0.1 : lims_temp[end]+1;
ssaltA = repeat(reshape(saltAi, 1, :), length(ctempi), 1);
cctemp = repeat(ctempi, 1, length(saltAi));
ssigma0 = gsw_sigma0.(ssaltA, cctemp);
sspice0 = gsw_spiciness0.(ssaltA, cctemp);

htemp = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = ctemp[tind], seriestype=:scatter, c=:thermal, markersize = ms, markerstrokewidth = 0, legend = false, label="", clims=lims_temp, colorbar = false)
#Plots.contour!(sea064pld1d.t, -sea064pld1d.z, sigma0);
hsalt = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = saltA[tind], seriestype=:scatter, c=:haline, markersize = ms, markerstrokewidth = 0, legend = false, label="", clims=lims_salt, colorbar = false)
hsigma0 = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = sigma0[tind], seriestype=:scatter, c=:jet, markersize = ms, markerstrokewidth = 0, legend = false, label="", clims=lims_sigma0, colorbar = true)
hspice0 = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = spice0[tind], seriestype=:scatter, c=:jet, markersize = ms, markerstrokewidth = 0, legend = false, label="", clims=lims_spice0, colorbar = false)
hsndspd = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = sndspd[tind], seriestype=:scatter, c=:jet, markersize = ms, markerstrokewidth = 0, legend = false, label="", clims=lims_sndspd, colorbar = false)
hUeast = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = ad2cp_Ueast[tind], seriestype=:scatter, c=:vik, markersize = ms, markerstrokewidth = 0, legend = false, label="", clims=lims_uv, colorbar = false)
hUnorth = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = ad2cp_Unorth[tind], seriestype=:scatter, c=:vik, markersize = ms, markerstrokewidth = 0, legend = false, label="", clims=lims_uv, colorbar = false)

hN2 = Plots.plot(tmid[tindmid], zmid[tindmid], zcolor = n2[tindmid], seriestype=:scatter, c=:jet, markersize = ms, markerstrokewidth = 0, legend = false, label="", clims=(0, 0.0001))
hMReps1 = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = log10.(mr_eps1[tind]), seriestype=:scatter, c=:jet, markersize = ms, markerstrokewidth = 0, legend = false, label="", clims=(-12, -5.5))
hMReps2 = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = log10.(mr_eps2[tind]), seriestype=:scatter, c=:jet, markersize = ms, markerstrokewidth = 0, legend = false, label="", clims=(-12, -5.5))
hMRqc1 = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = mr_qc1[tind], seriestype=:scatter, c=:jet, markersize = ms, markerstrokewidth = 0, legend = false, label="")
hMRqc2 = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = mr_qc2[tind], seriestype=:scatter, c=:jet, markersize = ms, markerstrokewidth = 0, legend = false, label="")
hMRsh1std = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = log10.(mr_sh1_std[tind]), seriestype=:scatter, c=:jet, markersize = ms, markerstrokewidth = 0, legend = false, label="")
hMRsh2std = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = log10.(mr_sh2_std[tind]), seriestype=:scatter, c=:jet, markersize = ms, markerstrokewidth = 0, legend = false, label="")

hchla = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = chla[tind], seriestype=:scatter, c=:jet, markersize = ms, markerstrokewidth = 0, legend = false, label="", clims=(0, 0.6))
hbb700 = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = log10.(bb700[tind] .+ 0.0001), seriestype=:scatter, c=:jet, markersize = ms, markerstrokewidth = 0, legend = false, label="", clims=(-5, -3))
hcdom = Plots.plot(sea064pld1d.t[tind], -sea064pld1d.z[tind], zcolor = cdom[tind], seriestype=:scatter, c=:jet, markersize = ms, markerstrokewidth = 0, legend = false, label="", clims=(0, 1.0))


hTS = Plots.plot(saltA[tind], ctemp[tind], zcolor = sigma0[tind], seriestype=:scatter, c=:jet, markersize = ms, markerstrokewidth = 0, legend = false, label="", clims=lims_sigma0, xlims=lims_salt, ylim=lims_temp, colorbar = false)
Plots.contour!(saltAi, ctempi, ssigma0, contour_labels=true, seriescolor = :black)
Plots.contour!(saltAi, ctempi, sspice0, contour_labels=true, seriescolor = :black)

norsephysplot = Plots.plot(htemp, hsalt, hsigma0, hspice0, hsndspd, hMReps1, hUeast, hUnorth, layout = l8out8, size=(1200,1700), framestyle=:box, legend=:outertopright, title=["Temperature" "Salinity" "Sigma0" "Spice0" "Sound Speed" "TKE EPS1" "U (east)" "V (north)"]);
norseMRplot = Plots.plot(hN2, hMReps1, hMReps2, hMRsh1std, hMRsh2std, hMRqc1, hMRqc2, layout = l8out7, size=(1200,1500), framestyle=:box, legend=:outertopright, title=["N2" "TKE EPS1" "TKE EPS2" "Shear 1 STDDEV" "Shear 2 STDDEV" "QC1" "QC2"]);
norseTSplot = Plots.plot(hTS, size=(1000,1000), framestyle=:box, title="CT vs SA");
norseoptcplot = Plots.plot(htemp, hchla, hbb700, hcdom, layout = l8out4, size=(1200,1000), framestyle=:box, legend=:outertopright, title=["Temperature" "Chlorophyll-a" "BB 700" "CDOM"]);

Plots.savefig(norsephysplot, figoutdir * "norse_sea064_" * region * "_physics.html");
Plots.savefig(norseMRplot, figoutdir * "norse_sea064_" * region * "_MR.html");
Plots.savefig(norseTSplot, figoutdir * "norse_sea064_" * region * "_TS.html");

#gr()
#norseEPS1plot = Plots.plot(hMReps1, size = (1000,800), framestyle=:box, markersize = 3, title="SEA064 RT EPS1")
#Plots.savefig(norseEPS1plot, figoutdir * "norse_sea064_MReps1.png");

Plots.savefig(norseoptcplot, figoutdir * "norse_sea064_" * region * "_optics.html");

#norseplot = Plots.plot(htemp, hsalt, layout = l8out, size=(1300,1300), framestyle=:box, legend=:outertopright, title=["temperature" "salinity"]);
#Plots.savefig(norseplot, "norse_temp_salt.html")

#pFLUOR = Plots.plot(Dates.Date.(flt), flz, zcolor = flv, seriestype=:scatter, c=:algae, markersize = 3, markerstrokewidth = 0, legend = false, label="Chl-a Fluorescence");
#Plots.plot!(Dates.Date.([t1 t2]),[0 0], label="")
