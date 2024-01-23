let
    Source = Table.FromList(Jira_Boards[Board.id], Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Column1", type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"Column1", "Board.id"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns", "getBoardSprints", each getBoardSprints([Board.id])),
    #"Expanded getBoardSprints" = Table.ExpandTableColumn(#"Invoked Custom Function", "getBoardSprints", {"Column1"}, {"Column1"}),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Expanded getBoardSprints", "Column1", {"id", "state", "name", "startDate", "endDate", "completeDate", "originBoardId"}, {"Sprint.id", "Sprint.state", "Sprint.name", "Sprint.startDate", "Sprint.endDate", "Sprint.completeDate", "originBoardId"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Expanded Column1",{{"Sprint.startDate", type datetime}, {"Sprint.endDate", type datetime}, {"Sprint.completeDate", type datetime}})
in
    #"Changed Type1"