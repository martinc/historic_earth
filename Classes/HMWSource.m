//
//  HMWSource.m
//  History
//
//  Created by Martin Ceperley on 8/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HMWSource.h"


@implementation HMWSource


-(NSString*) tileURL: (RMTile) tile
{

	
	NSString *base = @"http://www.historicmapworks.com/iPhone/request.php?REQUEST=GetMap&HEIGHT=256&WIDTH=256&TRANSPARENT=true&TILED=true&FORMAT=image%2Fpng8";
	
	NSString *suffix = @"&LAYERS=topp%3A28073&BBOX=-75.1490228610383,39.9472066432473,-75.13999979235484,39.95622971193075";
	
	NSString *address = [NSString stringWithFormat:@"%@%@", base, suffix];
	
	NSLog(@"loading URL  : %@",address);
	
	return address;
	
	/*
	var baseURL = "http://localhost/cgi-bin/mapserv?"; //begining of the WMS URL ending with a "?" or a "&".
	var format = "image/jpeg"; //type of image returned
	var layers = "example_layer"; //WMS layers to display
	var styles = ""; //styles to use for the layers
	var srs = "EPSG:4326"; //projection to display. Don't change unless you know what you are doing.
	var ts = this.tileSize;
	var ul = this.getLatLng(x*ts,(y+1)*ts, zoom);
	var lr = this.getLatLng((x+1)*ts,y*ts, zoom);
	var bbox = ul.x + "," + ul.y + "," + lr.x + "," + lr.y;
	var url = baseURL + "version=1.1.1&request=GetMap&Layers=" + layers + "&Styles=" + styles + "&SRS="+ srs +"&BBOX=" + bbox + "&width=" + ts +"&height=" + ts + "&format=" + format + "&transparent=true";
	return url;
	*/
	
	
}

/*

double const MAGIC_NUMBER = 6356752.3142;
double const DEG2RAD = 0.0174532922519943;

-(double) dd2MercMetersLng: (double) p_lng {
    return MAGIC_NUMBER * (p_lng * DEG2RAD);
}

-(double) dd2MercMetersLat: (double) p_lat {
    if (p_lat >= 85) p_lat = 85;
    if (p_lat <= -85) p_lat = -85;
    return MAGIC_NUMBER * log(tan(((p_lat * DEG2RAD) + (M_PI / 2.0)) / 2.0));
}

-(NSString *) CustomGetTileUrl = function(a, b, c) {
    if (typeof(window['this.myMercZoomLevel']) == "undefined") this.myMercZoomLevel = 0;
    if (typeof(window['this.myStyles']) == "undefined") this.myStyles = "";
    var lULP = new GPoint(a.x * 256, (a.y + 1) * 256);
    var lLRP = new GPoint((a.x + 1) * 256, a.y * 256);
	
	
	CGPoint upperLeftPoint = CGPointMake(tile.x * 256, (tile.y+1) * 256);
	CGPoint upperRightPoint = CGPointMake((tile.x+1)*256, tile.y * 256);

	
    var lUL = G_NORMAL_MAP.getProjection().fromPixelToLatLng(lULP, b, c);
    var lLR = G_NORMAL_MAP.getProjection().fromPixelToLatLng(lLRP, b, c);
    // switch between Mercator and DD if merczoomlevel is set
    if (this.myMercZoomLevel != 0 && map.getZoom() < this.myMercZoomLevel) {
        var lBbox = dd2MercMetersLng(lUL.lngDegrees) + "," + dd2MercMetersLat(lUL.latDegrees) + "," + dd2MercMetersLng(lLR.lngDegrees) + "," + dd2MercMetersLat(lLR.latDegrees);
        var lSRS = "EPSG:54004";
    } else {
        var lBbox = lUL.x + "," + lUL.y + "," + lLR.x + "," + lLR.y;
        var lSRS = "EPSG:4326";
    }
    var lURL = this.myBaseURL;
    lURL += "&REQUEST=GetMap";
    lURL += "&SERVICE=WMS";
    lURL += "&VERSION=" + this.myVersion;
    lURL += "&LAYERS=" + this.myLayers;
    lURL += "&STYLES=" + this.myStyles;
    lURL += "&FORMAT=" + this.myFormat;
    lURL += "&BGCOLOR=" + this.myBgColor;
    lURL += "&TRANSPARENT=TRUE";
    lURL += "&SRS=" + lSRS;
    lURL += "&BBOX=" + lBbox;
    lURL += "&WIDTH=256";
    lURL += "&HEIGHT=256";
    lURL += "&reaspect=false";
    return lURL;
}


*/
+(int)tileSideLength;
{
	return 256;
}

-(float) minZoom
{
	return 1.0;
}

-(float) maxZoom
{
	return 20.0;
}

-(NSString *)shortName
{
	return @"HMW";
}
-(NSString *)longDescription
{
	return @"Historic MapWorks";
}
-(NSString *)shortAttribution;
{
	return @"Historic MapWorks";
}
-(NSString *)longAttribution;
{
	return @"Historic MapWorks Long Attricution";
}

@end
