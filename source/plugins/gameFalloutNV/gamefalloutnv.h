#ifndef GAMEFALLOUTNV_H
#define GAMEFALLOUTNV_H


#include "falloutnvbsainvalidation.h"
#include "falloutnvscriptextender.h"
#include "falloutnvdataarchives.h"
#include <gamegamebryo.h>
#include <QFileInfo>


class GameFalloutNV : public GameGamebryo
{
  Q_OBJECT
#if QT_VERSION >= QT_VERSION_CHECK(5,0,0)
  Q_PLUGIN_METADATA(IID "org.tannin.GameFalloutNV" FILE "gamefalloutnv.json")
#endif

public:

  GameFalloutNV();

  virtual bool init(MOBase::IOrganizer *moInfo) override;

public: // IPluginGame interface

  virtual QString gameName() const;
  virtual QList<MOBase::ExecutableInfo> executables();
  virtual void initializeProfile(const QDir &path, ProfileSettings settings) const;
  virtual QString savegameExtension() const;
  virtual QString steamAPPId() const;
  virtual QStringList getPrimaryPlugins();
  virtual QIcon gameIcon() const override;

public: // IPlugin interface

  virtual QString name() const;
  virtual QString author() const;
  virtual QString description() const;
  virtual MOBase::VersionInfo version() const;
  virtual bool isActive() const;
  virtual QList<MOBase::PluginSetting> settings() const;

protected:

  virtual const std::map<std::type_index, boost::any> &featureList() const;

private:

  virtual QString identifyGamePath() const override;
  virtual QString myGamesFolderName() const override;

  QString localAppFolder() const;
  void copyToProfile(const QString &sourcePath, const QDir &destinationDirectory,
                     const QString &sourceFileName, const QString &destinationFileName = QString()) const;

private:

  std::shared_ptr<ScriptExtender> m_ScriptExtender { nullptr };
  std::shared_ptr<DataArchives> m_DataArchives { nullptr };
  std::shared_ptr<BSAInvalidation> m_BSAInvalidation { nullptr };

};

#endif // GAMEFALLOUTNV_H
