"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
class ConfigurationValidator {
    isCommandValid(command) {
        return __awaiter(this, void 0, void 0, function* () {
            if (command.startsWith(':')) {
                return true;
            }
            return (yield this.getCommandMap()).has(command);
        });
    }
    isRemappingValid(remapping) {
        return __awaiter(this, void 0, void 0, function* () {
            if (!remapping.after && !remapping.commands) {
                return [{ level: 'error', message: `${remapping.before} missing 'after' key or 'command'.` }];
            }
            if (remapping.commands) {
                for (const command of remapping.commands) {
                    let cmd;
                    if (typeof command === 'string') {
                        cmd = command;
                    }
                    else {
                        cmd = command.command;
                    }
                    if (!(yield exports.configurationValidator.isCommandValid(cmd))) {
                        return [{ level: 'warning', message: `${cmd} does not exist.` }];
                    }
                }
            }
            return [];
        });
    }
    getCommandMap() {
        return __awaiter(this, void 0, void 0, function* () {
            if (this._commandMap == null) {
                this._commandMap = new Map((yield vscode.commands.getCommands(true)).map(x => [x, true]));
            }
            return this._commandMap;
        });
    }
}
exports.configurationValidator = new ConfigurationValidator();

//# sourceMappingURL=configurationValidator.js.map
