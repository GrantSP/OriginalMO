#ifndef GAMEOBLIVION_H
#define GAMEOBLIVION_H


#include "oblivionbsainvalidation.h"
#include "oblivionscriptextender.h"
#include "obliviondataarchives.h"
#include <gamegamebryo.h>
#include <QFileInfo>


class GameOblivion : public GameGamebryo
{
  Q_OBJECT
#if QT_VERSION >= QT_VERSION_CHECK(5,0,0)
  Q_PLUGIN_METADATA(IID "org.tannin.GameOblivion" FILE "gameoblivion.json")
#endif

public:

  GameOblivion();

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

#endif // GAMEOBLIVION_H
