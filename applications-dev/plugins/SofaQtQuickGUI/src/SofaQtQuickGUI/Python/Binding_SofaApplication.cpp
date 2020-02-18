
#include <SofaPython3/DataHelper.h>
#include <SofaPython3/PythonFactory.h>
#include <SofaPython3/Sofa/Core/Binding_Base.h>
#include <SofaPython3/Sofa/Core/Binding_BaseData.h>

#include <SofaQtQuickGUI/SofaBaseApplication.h>
#include <SofaQtQuickGUI/SofaProject.h>
#include <SofaQtQuickGUI/SofaBaseScene.h>

#include "Binding_SofaApplication.h"
#include "Binding_SofaApplication_doc.h"

#include <QUrl>

namespace sofapython3
{

void moduleAddSofaApplication(py::module& m)
{
    m.def("setProjectDirectory", [](const std::string& path){
        sofaqtquick::SofaBaseApplication::Instance()->setProjectDirectory(path);
    });
    m.def("getProjectDirectory", [](){
        return sofaqtquick::SofaBaseApplication::Instance()->getProjectDirectory();
    });

    auto scene = m.def_submodule("Scene");

    scene.def("play", [](){
        return sofaqtquick::SofaBaseApplication::Instance()->getCurrentProject()->getScene()->setAnimate(true);
    });
    scene.def("pause", [](){
        return sofaqtquick::SofaBaseApplication::Instance()->getCurrentProject()->getScene()->setAnimate(false);
    });
    scene.def("step", [](){
        return sofaqtquick::SofaBaseApplication::Instance()->getCurrentProject()->getScene()->step();
    });

    scene.def("setSource", [](const std::string& source){
        sofaqtquick::SofaBaseApplication::Instance()->getCurrentProject()->getScene()->setSource(QUrl(QString::fromStdString(source)));
    });
    scene.def("getSource", [](){
        return sofaqtquick::SofaBaseApplication::Instance()->getCurrentProject()->getScene()->source().toString().toStdString();
    });

}

}  // namespace sofapython3
