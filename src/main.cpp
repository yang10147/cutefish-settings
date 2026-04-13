/*
 * Copyright (C) 2021 CutefishOS Team.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 */

#include "application.h"
#include <QIcon>
#include <cstdlib>

int main(int argc, char *argv[])
{
    // 必须在 QApplication 创建前设置，否则 KDE style 会覆盖 ScrollBar
    setenv("QT_QUICK_CONTROLS_STYLE", "Basic", 1);

    Application app(argc, argv);
    app.setWindowIcon(QIcon::fromTheme("cutefish-settings"));
    return 0;
}
