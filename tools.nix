{
  icpc-presentation = {
    archive = "presentations";
    description = "ICPC Tools presentation client";
    mainProgram = "presentation-client";
    programs.presentation-client = "org.icpc.tools.presentation.contest.internal.ClientLauncher";
  };

  icpc-presentation-admin = {
    archive = "presentationAdmin";
    description = "ICPC Tools presentation admin";
    mainProgram = "presentation-admin";
    programs.presentation-admin = "org.icpc.tools.presentation.admin.internal.Admin";
    usesSwt = true;
  };

  icpc-resolver = {
    archive = "resolver";
    description = "ICPC Tools resolver";
    mainProgram = "resolver";
    programs = {
      resolver = "org.icpc.tools.resolver.Resolver";
      awards = "org.icpc.tools.resolver.awards.Awards";
    };
    usesSwt = true;
  };
}
