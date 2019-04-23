#pragma once

#include "Asset.h"

namespace sofa
{
namespace qtquick
{

template <class T>
struct TextureAssetLoader : public TBaseAssetLoader<T>
{
    BaseObject* New() override { return sofa::core::objectmodel::New<T>().get(); }
};

class TextureAsset : public Asset
{
  public:
    TextureAsset(std::string path, std::string extension);
    virtual SofaComponent* getPreviewNode() override;

    static const QUrl iconPath;
    static const QString typeString;
    static const LoaderMap loaders;

    static LoaderMap createLoaders();
};

} // namespace qtquick
} // namespace sofa