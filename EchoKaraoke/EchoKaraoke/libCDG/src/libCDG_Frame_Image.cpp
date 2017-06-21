/*
 * Copyright (c) 2013-2014 Thomas Isaac Lightburn
 *
 *
 * This file is part of libCDG.
 *
 * OpenKJ is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "../include/libCDG_Frame_Image.h"


unsigned char *CDG_Frame_Image::Get_RGB_Data()
{
	void *ptr;
	unsigned char *imgdata;
	unsigned int row;
    ptr = malloc(259200 * sizeof(unsigned char));
	imgdata = (unsigned char *)ptr;
	for (unsigned int y=0; y<216; y++)
	{
		row = y*1200;
		for (unsigned int x=0; x<300; x++)
		{
			memcpy(imgdata + ((x*4) + row), &colors[CDG_Map[y][x]].rgb , 4);
		}
	}
	return imgdata;
};

unsigned char *CDG_Frame_Image::Get_Row_Data(int cdgrow)
{
    int rowstart = cdgrow * 12;
    void *ptr;
    unsigned char *rowdata;
    unsigned int row;
    ptr = malloc(10800 * sizeof (unsigned char));
    rowdata = (unsigned char *)ptr;
    for (unsigned int y=0; y<12; y++)
    {
        // padding the alpha, so you see 900 instead of 1200.  and 4 instead of 3
        row = y*1200;
        for (unsigned int x=0; x<300; x++)
        {
            memcpy(rowdata + ((x*4) + row), &colors[CDG_Map[y + rowstart][x]].rgb, 4);
        }
    }
    return rowdata;
}

void CDG_Frame_Image::Get_RGB_Data(unsigned char * pRGB)
{
	unsigned int row;
	for (unsigned int y=0; y<216; y++)
	{
		row = y*900;
		for (unsigned int x=0; x<300; x++)
		{
			memcpy(pRGB + ((x*3) + row), &colors[CDG_Map[y][x]].rgb , 3);
		}
	}
}

bool CDG_Frame_Image::RowChanged(int row) {
    bool ret = false;
    for (unsigned int i=0; i < ChangedRows.size(); i++)
    {
        if (row == ChangedRows.at(i)) ret = true;
    }
    return ret;
}
