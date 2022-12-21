import { useState, useEffect, useRef } from "react";
import { Form, Stack, TextInput, Select, SelectItem, Button, InlineLoading, IconButton, Search, Toggle, Switch } from '@carbon/react';
import { Add, Subtract } from '@carbon/react/icons';
import Autocomplete from "../inputComponents/AutoComplete";
import RuleBuilderFormValues from "../formModel/ruleBuilder/RuleBuilderFormValues";
import { actionOptions ,relationOptions ,overallOptions } from "../data/ReflexRuleOptions";
import { getFromOpenElisServer, postToOpenElisServer } from "../utils/Utils";

function ReflexRule() {
  const componentMounted = useRef(true);
  const FIELD = {
    conditions: "conditions",
    actions: "actions"
  }
  const conditionsObj = {
    id : null ,
    sampleId: "",
    testName: "",
    testId: "",
    relation: "",
    value: ""
  }
  const actionObj = {
    id : null ,
    action: "",
    reflexResult: "",
    reflexResultTestId: ""
  }
  const ruleObj = {
    id : null ,
    ruleName: "",
    overall: "",
    toggled: true,
    conditions: [conditionsObj],
    actions: [actionObj]
  }

  //const [ruleList, setRuleList] = useState([ruleObj]);
  const [ruleList, setRuleList] = useState([RuleBuilderFormValues]);

  const [testList, setTestList] = useState([]);

  const [sampleList, setSampleList] = useState([]);


  useEffect(() => {
    getFromOpenElisServer("/rest/tests", fetchTests)
    getFromOpenElisServer("/rest/samples", fetchSamples)
    getFromOpenElisServer("/rest/reflexrules", fetchReflexRules)

    return () => { // This code runs when component is unmounted
      componentMounted.current = false;
    }

  }, []);

  const handleRuleFieldChange = (e, index) => {
    const { name, value } = e.target;
    const list = [...ruleList];
    list[index][name] = value;
    setRuleList(list);
  };

  const handleRuleFieldItemChange = (e, index, itemIndex, field) => {
    const { name, value } = e.target;
    const list = [...ruleList];
    list[index][field][itemIndex][name] = value;
    setRuleList(list);
  }

  const handleRuleRemove = (index) => {
    const list = [...ruleList];
    list.splice(index, 1);
    setRuleList(list);
  };

  const handleRuleAdd = () => {
    setRuleList([...ruleList, ruleObj]);
  };

  const toggleRule = (e, index) => {
    const list = [...ruleList];
    list[index]["toggled"] = e;
    setRuleList(list);
  }

  const handleRuleFieldItemAdd = (index, field, fieldObj) => {
    const list = [...ruleList];
    list[index][field].push(fieldObj);
    setRuleList(list);
  };

  const handleRuleFieldItemRemove = (index, itemIndex, field) => {
    const list = [...ruleList];
    list[index][field].splice(itemIndex, 1);
    setRuleList(list);
  };

  const handlePost = (status) => {
    alert(status)
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    //setRuleList([...ruleList, { rule: "" }]);
     console.log(JSON.stringify(ruleList))
     postToOpenElisServer("/rest/reflexrule" ,JSON.stringify(ruleList) , handlePost)
  };

  const fetchTests = (testList) => {
    if (componentMounted.current) {
      setTestList(testList);
    }
  }

  const fetchSamples = (sampleList) => {
    if (componentMounted.current) {
      setSampleList(sampleList);
    }
  }

  const fetchReflexRules = (reflexRuleList) => {
    if (componentMounted.current) {
      console.log(JSON.stringify(reflexRuleList))
    }
  }

  return (
    <>
      {ruleList.map((rule, index) => (

        <div key={index} className="rules">
          <div className="first-division">
            <Form
              onSubmit={handleSubmit}
            >
              <Stack gap={7}>
                <div className="ruleBody">
                  <div className="inlineDiv">
                    <div>
                      <TextInput
                        name="ruleName"
                        className="inputText"
                        type="text"
                        id={index + "_rulename"}
                        labelText="Rule Name"
                        value={rule.ruleName}
                        onChange={(e) => handleRuleFieldChange(e, index)}
                        required
                      />
                    </div>
                    <div >
                      &nbsp;  &nbsp;
                    </div>
                    <div >
                      <Toggle
                        toggled={rule.toggled}
                        aria-label="toggle button"
                        id={index + "_toggle"}
                        labelText="Label text"
                        onToggle={(e) => toggleRule(e, index)}
                      />
                    </div>
                  </div>
                  {rule.toggled && (

                    <>
                      <div className="section">
                        <div className="inlineDiv">
                          <div >
                            If &nbsp;
                          </div>
                          <div >
                            <Select
                              value={rule.overall}
                              id={index + "_overall"}
                              name="overall"
                              labelText=""
                              className="inputSelect"
                              onChange={(e) => handleRuleFieldChange(e, index)}
                              required
                            >
                              <SelectItem
                                  text=""
                                  value=""
                                />
                               {overallOptions.map((overall, overall_index) => (
                                  <SelectItem
                                    text={overall.label}
                                    value={overall.value}
                                    key={overall_index}
                                  />
                                ))}
                            </Select>
                          </div>
                          <div >
                            &nbsp; of the following conditions are met
                          </div>
                        </div>
                        {rule.conditions.map((condition, condition_index) => (
                          <div key={index + "_" + condition_index} className="inlineDiv">
                            <div>
                              If a Sample is &nbsp;
                            </div>
                            <div >
                              <Select
                                id={index + "_" + condition_index + "_sample"}
                                name="sampleId"
                                labelText=""
                                value={condition.sample}
                                className="inputSelect"
                                onChange={(e) => handleRuleFieldItemChange(e, index, condition_index, FIELD.conditions)}
                                required
                             >
                               <SelectItem
                                  text=""
                                  value=""
                                />
                                {sampleList.map((sample, sample_index) => (
                                  <SelectItem
                                    text={sample.value}
                                    value={sample.id}
                                    key={sample_index}
                                  />
                                ))}
                              </Select>
                            </div>
                            <div>
                              &nbsp; And the Test &nbsp;
                            </div>
                            <div>
                              <Autocomplete
                                stateValue={condition.testName}
                                handleChange={handleRuleFieldItemChange}
                                index={index}
                                name="testName"
                                idField="testId"
                                class="autocomplete1"
                                item_index={condition_index}
                                field={FIELD.conditions}
                                suggestions={testList}
                                required
                                 />
                            </div>
                            <div>
                              &nbsp;  &nbsp;
                            </div>
                            <div >
                              <Select
                                value={condition.relation}
                                id={index + "_" + condition_index + "_relation"}
                                name="relation"
                                labelText=""
                                className="inputSelect"
                                onChange={(e) => handleRuleFieldItemChange(e, index, condition_index, FIELD.conditions)}
                                required
                              >
                                <SelectItem
                                  text=""
                                  value=""
                                />
                                 {relationOptions.map((relation, relation_index) => (
                                  <SelectItem
                                    text={relation.label}
                                    value={relation.value}
                                    key={ relation_index}
                                  />
                                ))}
                              </Select>
                            </div>
                            <div>
                              &nbsp;  &nbsp;
                            </div>
                            <div >
                              <Select
                                value={condition.value}
                                id={index + "_" + condition_index + "_value"}
                                name="value"
                                labelText=""
                                className="inputSelect"
                                onChange={(e) => handleRuleFieldItemChange(e, index, condition_index, FIELD.conditions)}
                                required
                              >
                                <SelectItem
                                  text=""
                                  value=""
                                />
                                <SelectItem
                                  text="Postive"
                                  value="postive"
                                />
                                <SelectItem
                                  text="Negative"
                                  value="negative"
                                />
                              </Select>
                            </div>
                            <div>
                              &nbsp;  &nbsp;
                            </div>
                            {rule.conditions.length - 1 === condition_index && (
                              <div >
                                <IconButton label="" onClick={() => handleRuleFieldItemAdd(index, FIELD.conditions, conditionsObj)} kind='tertiary' size='sm'>  <Add size={18} /></IconButton>
                              </div>
                            )}
                            <div>
                              &nbsp;  &nbsp;
                            </div>
                            {rule.conditions.length !== 1 && (
                              <div >
                                <IconButton label="" onClick={() => handleRuleFieldItemRemove(index, condition_index, FIELD.conditions)} kind='tertiary' size='sm'>  <Subtract size={18} /></IconButton>
                              </div>
                            )}
                          </div>
                        ))}
                      </div>
                      <div className="section">
                        <div className="inlineDiv">
                          <div >
                            <h5>Perform the following actions </h5> &nbsp;
                          </div>
                        </div>
                        {rule.actions.map((action, action_index) => (
                          <div key={index + "_" + action_index} className="inlineDiv">
                            <div >
                              <Select
                                value={action.action}
                                id={index + "_" + action_index + "_value"}
                                name="action"
                                labelText=""
                                className="inputSelect"
                                onChange={(e) => handleRuleFieldItemChange(e, index, action_index, FIELD.actions)}
                                required
                              >
                                 <SelectItem
                                  text=""
                                  value=""
                                />
                                 {actionOptions.map((action, action_index) => (
                                  <SelectItem
                                    text={action.label}
                                    value={action.value}
                                    key={action_index}
                                  />
                                ))}
                              </Select>
                            </div>
                            <div>
                              &nbsp;  &nbsp;
                            </div>
                            <div>
                              <Autocomplete
                                stateValue={action.reflexResult}
                                handleChange={handleRuleFieldItemChange}
                                index={index}
                                name="reflexResult"
                                idField="reflexResultTestId"
                                item_index={action_index}
                                field={FIELD.actions}
                                class="autocomplete2"
                                suggestions={testList} />
                            </div>
                            <div>
                              &nbsp;  &nbsp;
                            </div>
                            {rule.actions.length - 1 === action_index && (
                              <div >
                                <IconButton label="" onClick={() => handleRuleFieldItemAdd(index, FIELD.actions, actionObj)} kind='tertiary' size='sm'>  <Add size={18} /></IconButton>
                              </div>
                            )}
                            <div>
                              &nbsp;  &nbsp;
                            </div>
                            {rule.actions.length !== 1 && (
                              <div >
                                <IconButton label="" onClick={() => handleRuleFieldItemRemove(index, action_index, FIELD.actions)} kind='tertiary' size='sm'>  <Subtract size={18} /></IconButton>
                              </div>
                            )}
                          </div>
                        ))}
                      </div>
                      <Button type="submit" kind='tertiary' size='sm'>
                        Submit
                      </Button>
                    </>
                  )}
                </div>
              </Stack>
            </Form >
            {ruleList.length - 1 === index && (
              <button
                onClick={handleRuleAdd}
                className="add_button"
              >
                <Add size={16} />
                <span>Rule</span>
              </button>
            )}

          </div>
          <div className="second-division">
            {ruleList.length !== 1 && (
              <button
                type="button"
                onClick={() => handleRuleRemove(index)}
                className="remove-btn">
                <Subtract size={16} />
              </button>
            )}
          </div>
        </div>

      ))}

    </>
  );
}

export default ReflexRule;