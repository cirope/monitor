(function() {
    // Create the connector object
    var myConnector = tableau.makeConnector();

    // Define the schema
    myConnector.getSchema = function(schemaCallback) {
        var cols = [{
            id: "Item+Desc",
            dataType: tableau.dataTypeEnum.string
        }, {
            id: "Desc_Familia",
            dataType: tableau.dataTypeEnum.string
        }, {
            id: "Planta+Desc",
            dataType: tableau.dataTypeEnum.string
        }, {
            id: "Estado",
            dataType: tableau.dataTypeEnum.string
        }];

        var tableSchema = {
            id: "issues",
            alias: "Listado de casos según el guión especificado",
            columns: cols
        };

        schemaCallback([tableSchema]);
    };

    // Download the data
    myConnector.getData = function(table, doneCallback) {
        $.ajax({
          type: "GET",
          crossDomain: true,
          dataType: "json",
          url: "http://localhost:3000/api/v1/scripts/1/issues",
          headers: {
            'Authorization': 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJhY2NvdW50X2lkIjoxNiwiZXhwIjoxNjg0OTMwNzMwfQ.hUy8jF_RfbQgb7AgfIGA3YH-XKwCyOlcIERCkmk6WLM'
          },
          error : function(jqXHR, textStatus, errorThrown) {
            console.log(jqXHR.status);
            console.log(textStatus);
          },
          success: function(resp) {
            var feat = resp.features,
                tableData = [];

            // Iterate over the JSON object
            for (var i = 0, len = feat.length; i < len; i++) {
                tableData.push({
                    "Item+Desc": feat[i].properties.Item+Desc,
                    "Desc_Familia": feat[i].properties.Desc_Familia,
                    "Planta+Desc": feat[i].properties.Planta+Desc,
                    "Estado": feat[i].properties.Estado
                });
            }

            table.appendRows(tableData);
            doneCallback();
          }
        });
    };

    myConnector.init = function(initCallback) {
      tableau.authType = tableau.authTypeEnum.basic;

      initCallback();
    };

    tableau.registerConnector(myConnector);

    // Create event listeners for when the user submits the form
    $(document).ready(function() {
        $("#submitButton").click(function() {
            tableau.connectionName = "USGS Earthquake Feed"; // This will be the data source name in Tableau
            tableau.submit(); // This sends the connector object to Tableau
        });
    });
})();
