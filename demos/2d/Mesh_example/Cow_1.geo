// Copyright (C) 2011 - Bouvet Paul-Edouard
// Copyright (C) 2011 - Chun Yuk Shan Nadège
// Copyright (C) 2011 - Mazzocco Pauline
// Copyright (C) 2011 - Moncel Marie
// Copyright (C) 2011 - Vacher Anthony
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//
// 
 Point(1) = {1.6, 4.15, 0};
Point(2) = {1.91, 4.15, 0};
 Point(3) = {1.5, 3.33, 0};
 Point(4) = {2, 3.33, 0};
 Point(5) = {2.66, 3.16, 0};
 Point(6) = {3.16, 3.16, 0};
 Point(7) = {3.16, 3, 0};
Point(8) = {2.66, 3, 0};
 Point(9) = {2.33, 2.83, 0};
 Point(10) = {2.33, 1.66, 0};
 Point(11) = {2.83, 1.5, 0};
 Point(12) = {3.16, 1.5, 0};
 Point(13) = {3.16, 1.33, 0};
 Point(14) = {1.91, 1.16, 0};
 Point(15) = {1.58, 1.16, 0};
 Point(16) = {0.33, 1.33, 0};
 Point(17) = {0.33, 1.5, 0};
 Point(18) = {0.66, 1.5, 0};
Point(19) = {1.16, 1.66, 0};
 Point(20) = {1.16, 2.83, 0};
 Point(21) = {0.83, 3, 0};
 Point(22) = {0.33, 3, 0};
 Point(23) = {0.33, 3.16, 0};
 Point(24) = {0.83, 3.16, 0};
 Point(25) = {1.7, 0.3, 0};
 Point(26) = {1.8, 0.3, 0};
Line(1) = {20, 21};
Line(2) = {21, 22};
Line(3) = {22, 23};
Line(4) = {23, 24};
Line(5) = {24, 3};
Line(6) = {3, 1};
Line(7) = {1, 2};
Line(8) = {2, 4};
Line(9) = {4, 5};
Line(10) = {5, 6};
Line(11) = {6, 7};
Line(12) = {7, 8};
Line(13) = {8, 9};
Line(14) = {9, 10};
Line(15) = {10, 11};
Line(16) = {11, 12};
Line(17) = {12, 13};
Line(18) = {13, 14};
Line(19) = {14, 26};
Line(20) = {26, 25};
Line(21) = {25, 15};
Line(22) = {15, 16};
Line(23) = {16, 17};
Line(24) = {17, 18};
Line(25) = {18, 19};
Line(26) = {19, 20};
Line Loop(27) = {14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13};
Plane Surface(28) = {27};
